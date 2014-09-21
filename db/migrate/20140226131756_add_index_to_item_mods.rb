class AddIndexToItemMods < ActiveRecord::Migration
  def change
    change_table :item_mods do |t|
      t.index :id, order: { id: :desc }
	    t.index [:item_id, :mod_id]
      t.index [:total_value, :id], order: { total_value: :desc, id: :desc }
      t.index [:total_value, :mod_id], name: :total_value_mod_id_desc, order: { total_value: :desc }
      t.index [:total_value, :mod_id, :id], name: :total_value_mod_id_id_desc, order: { total_value: :desc, id: :desc }
      t.index [:mod_id, :id], order: { id: :desc }
      t.index [:total_value], name: :total_value_desc, order: { total_value: :desc }
    end
  end
end
