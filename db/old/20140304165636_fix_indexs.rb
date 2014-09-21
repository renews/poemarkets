class FixIndexs < ActiveRecord::Migration
  def change
    remove_index :item_mods, column: [:item_id, :mod_id]
    remove_index :item_mods, column: [:item_id, :mod_id, :total_value, :id], order: { total_value: :desc, id: :desc }
  end
end
