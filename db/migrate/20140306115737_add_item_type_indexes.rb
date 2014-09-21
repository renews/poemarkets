class AddItemTypeIndexes < ActiveRecord::Migration
  def change
    add_index :item_mods, [:mod_id, :item_id, :total_value], order: { total_value: :desc }
    add_index :item_mods, [:total_value, :mod_id, :item_id], order: { total_value: :desc }
    add_index :item_mods, [:total_value, :item_id, :mod_id], order: { total_value: :desc }
    add_index :items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :one_h_item_type
    add_index :items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :two_h_item_type
  end
end
