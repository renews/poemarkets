class ItemMod < ActiveRecord::Base
  
	belongs_to :item
	belongs_to :mod
	
	def valued_mod
	  self.mod.name.sub('#', self.primary_value.to_s).sub('#', self.secondary_value.to_s)
  end
end
