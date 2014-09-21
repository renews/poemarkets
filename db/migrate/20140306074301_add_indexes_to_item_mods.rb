class AddIndexesToItemMods < ActiveRecord::Migration
  def change
  	remove_index :item_mods, column: :total_value, name: :total_value_desc, order: { total_value: :desc }
	remove_index :item_mods, column: [:total_value, :id], order: { total_value: :desc, id: :desc }
    remove_index :item_mods, column: [:total_value, :mod_id], name: :total_value_mod_id_desc, order: { total_value: :desc }
    remove_index :item_mods, column: [:total_value, :mod_id, :id], name: :total_value_mod_id_id_desc, order: { total_value: :desc, id: :desc }

    add_index :item_mods, [:item_id, :mod_id, :total_value], order: { total_value: :desc }
  end
end
