class AddIndexToShops < ActiveRecord::Migration
  def change
  	add_index :shops, :updated_at
  end
end
