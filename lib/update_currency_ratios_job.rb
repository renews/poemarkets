require 'open-uri'
require 'json'
require 'csv'

class UpdateCurrencyRatiosJob
  #include Resque::Plugins::UniqueJob

  @queue = :administration_queue

  def self.perform
  	ActiveRecord::Base.record_timestamps = false
  	# Insert new currency ratios
  	CurrencyRatio.all.destroy_all
  	
  	# League.all.each do |league|
  	#   url = "http://poexchange.info/api/rates/#{league.name}"
  	#   data = open(url) { |io| data = io.read }
   #    json = JSON.parse(data)
   #    rates = json["entries"]
   #    rates.each do |rate|
   #      next unless rate["orb2"] == "Chaos Orb"
   #      CurrencyRatio.find_or_create_by(league_id: league.id, currency_id: Currency.find_or_create_by(name: rate["orb1"]).id, chaos_ratio: rate["rate"])
   #      puts "created ratio for " + rate["orb1"]
   #    end
   #    CurrencyRatio.find_or_create_by(league_id: league.id, currency_id: Currency.find_or_create_by(name: "Scroll of Wisdom").id, chaos_ratio: 200)
	  # end
	  
	  # Add any missing ratios from defaults
	  CSV.foreach("#{ENV['RAILS_ROOT']}/lib/data/currency-ratios.csv") do |row|
      unless CurrencyRatio.exists?(league_id: League.find_by_name(row[0]).id, currency_id: Currency.find_or_create_by(name: row[1]).id)
        CurrencyRatio.find_or_create_by(league_id: League.find_by_name(row[0]).id, currency_id: Currency.find_or_create_by(name: row[1]).id, chaos_ratio: row[2])
      end
    end

	# Update all normalized buyouts
	Item.where('buyout_amount > ? AND buyout_currency_id IS NOT NULL', 0).includes(:league, :buyout_currency).find_each do |item|
		next if item.buyout_currency.nil? or item.buyout_currency.name == 'Chaos Orb'
		currency_ratio = CurrencyRatio.where(league_id: item.league.id, currency_id: item.buyout_currency.id).first
	 	item.update_attribute('normalized_buyout', item.buyout_amount/currency_ratio.chaos_ratio) unless currency_ratio.nil?
	end
  end
end