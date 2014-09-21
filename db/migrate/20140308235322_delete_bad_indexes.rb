class DeleteBadIndexes < ActiveRecord::Migration
  def change
    remove_index :item_mods, column: [:mod_id, :id], order: { id: :desc }
    
    add_index :item_mods, [:mod_id, :item_id, :id], name: :item_mods_composite_1, order: { id: :desc }
    add_index :item_mods, [:item_id, :mod_id, :id], name: :item_mods_composite_2, order: { id: :desc }
    add_index :item_mods, [:mod_id, :item_id]
    add_index :item_mods, [:item_id, :total_value, :mod_id], name: :item_mods_composite_3, order: { total_value: :desc }
    add_index :item_mods, [:mod_id, :total_value, :item_id], name: :item_mods_composite_4, order: { total_value: :desc }
    
  end
end
