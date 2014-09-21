class Addloadsofindexes < ActiveRecord::Migration
  def change
    add_index :items, :attacks_per_second
    add_index :items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :one_h_item_type
    add_index :items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :two_h_item_type
    add_index :items, :attacks_per_second, where: "attacks_per_second >= 1.4", name: :aps_gt
    add_index :items, :attacks_per_second, where: "attacks_per_second < 1.4", name: :aps_lt
    
    
    remove_index :items, column: [:league_id, :attacks_per_second,:id], order: { attacks_per_second: :desc, id: :desc }
    
  end
end
