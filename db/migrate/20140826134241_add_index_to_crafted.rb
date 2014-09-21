class AddIndexToCrafted < ActiveRecord::Migration
  def change
    add_index :item_mods, :crafted
  end
end
