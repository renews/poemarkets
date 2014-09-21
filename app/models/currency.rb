class Currency < ActiveRecord::Base
  
  has_many :items_for_buyout, foreign_key: :buyout_currency_id, class_name: "Item"
  has_many :currency_ratios
  
  default_scope { order(:name) }
end
