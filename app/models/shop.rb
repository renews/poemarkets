class Shop < ActiveRecord::Base
  
	has_many :items, dependent: :destroy
	belongs_to :seller
	
	def self.to_reindex
	  self.select(:id).where("last_indexed < ?", 3.days.ago)
	end
end
