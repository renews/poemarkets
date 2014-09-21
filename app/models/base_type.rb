class BaseType < ActiveRecord::Base
  
  has_many :items
  belongs_to :item_type
  
    default_scope { order :name }
end
