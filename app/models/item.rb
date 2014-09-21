class Item < ActiveRecord::Base
  
	has_many :item_mods, dependent: :destroy
	has_many :mods, through: :item_mods
	belongs_to :shop
	belongs_to :seller
	belongs_to :base_type
	belongs_to :item_type
	belongs_to :league
	belongs_to :buyout_currency, foreign_key: :buyout_currency_id, class_name: "Currency"
	has_one :currency_ratio, through: :buyout_currency, source: :currency_ratios
	
	def explicit_mods
	  self.item_mods.includes(:mod).where("mods.explicit = TRUE AND mods.total = FALSE").references(:mods)
  end
  
  def implicit_mods
    self.item_mods.includes(:mod).where("mods.explicit = FALSE AND mods.total = FALSE").references(:mods)
  end
  
  def resistance_mods
    resistances = ResistanceMod.all.map { |r| r.name }
    self.item_mods.includes(:mod).where("mods.total = FALSE AND mods.name IN (?)", resistances).references(:mods)
  end

  def icon
    uri = URI.parse(self.icon_url)
    url = 'http://webcdn.pathofexile.com' + uri.path
    url += '?' + uri.query unless uri.query.nil?
    url
  end
  
  def self.to_verify(max_age)
    self.select(:id, :shop_id).where("updated_at < ?", max_age)
  end
  
  def self.verify
    Resque.enqueue(VerifyJob, self)
  end
  
  def self.similar_names(text)
    items = self.select("DISTINCT(name), similarity(name, '#{%q[text]}') AS sml").where("name % ?", text).order('sml DESC').limit(10)
    items.map { |i| i.name }
  end
  
  def pm_content
    "Hi #{self.seller.account_name},\n
    \n
    I'm interested in buying your [b]#{self.name}[/b] as listed in your shop.\n
    \n
    My IGN is XXX\n
    \n
    Please contact me so we can arrange a trade\n
    Thanks\n
    (Sent using www.poemarkets.com)"
  end
	
end
