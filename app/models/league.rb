class League < ActiveRecord::Base
  
  has_many :items, dependent: :destroy
  has_many :forums, dependent: :destroy
  has_many :currency_ratios, dependent: :destroy
  belongs_to :region
  
  def create_view
    League.connection.execute("
    CREATE VIEW #{self.view_name} AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = #{self.id};
    ")
  end
  
  def drop_view
    begin
      League.connection.execute("
    DROP VIEW #{self.view_name};
    ")
    rescue
      Rails.logger.warn "Failed to delete view #{self.view_name}"
    end
  end
  
  def populate_ratios
    standard = League.find_by_name('Standard')
    ratios = CurrencyRatio.where(league: standard)
    
    ratios.each do |ratio|
      CurrencyRatio.create(league: self, currency: ratio.currency, chaos_ratio: ratio.chaos_ratio)
    end
  end
  
  def view_name
    (self.region.name + ' ' + self.name + ' items').parameterize.underscore
  end
end
