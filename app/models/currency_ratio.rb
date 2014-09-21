class CurrencyRatio < ActiveRecord::Base
  
  belongs_to :league
  belongs_to :currency
end
