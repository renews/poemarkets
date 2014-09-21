class AddItemIdIndexToItemMods < ActiveRecord::Migration
  def change
  	add_index :item_mods, [:mod_id, :item_id], order: { item_id: :desc }, name: :item_mods_mod_id_item_id_desc
  end
end
