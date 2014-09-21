require 'open-uri'
require 'json'
require 'le_logger'

class CheckOnlineJob
  include Resque::Plugins::UniqueJob
  
  @queue = :check_online_queue
  def self.perform
    hydra = Typhoeus::Hydra.new(max_concurrency: 6)
    League.all.each do |league|
      next if league.name.include?('Garena')
      league_name = Rack::Utils.escape(league.name)
      url = "http://api.pathofexile.com/ladders/#{league_name}?limit=200"
      begin
        data = open(url) { |io| data = io.read }
      rescue
        LOGGER.info "Not able to access #{url}"
        next
      end
      json = JSON.parse(data)
      total = json["total"].to_i
      json = nil
      requests = total / 200
      offset = 0
      requests.times do
        url = "http://api.pathofexile.com/ladders/#{league_name}?limit=200&offset=#{offset}"
        request = Typhoeus::Request.new(url, :followlocation => true)
        request.on_complete do |response|
          if response.success?
            json = JSON.parse(response.body)
            accounts = json["entries"]
            json = nil
            accounts.each do |account|
              seller = Seller.find_by_account_name(account["account"]["name"])
              unless seller.nil? 
                if account["online"]
                  seller.online = true
                  seller.last_seen_online = Time.now
                elsif seller.online_until.nil?
                  seller.online = false
                end
                seller.save if seller.changed?
              end
            end
          else
            raise "Unsuccessful request: #{request.inspect}"
          end     
        end
        hydra.queue request
        offset += 200
      end
    end
    hydra.run
    
    #set offline sellers
    Seller.online.each do |seller|
      if seller.online_until and seller.online_until < Time.now
        seller.online = false
        seller.online_until = nil
      end
      seller.save if seller.changed?
    end
    true
  end
end