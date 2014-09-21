class DeleteCrappyIndexes3 < ActiveRecord::Migration
  def change
  	remove_index :items, :quality
  	remove_index :items, :created_at
  	remove_index :items, :buyout_amount
  	remove_index :items, :id_and_normalized_buyout
  	remove_index :items, :links
  	remove_index :items, :id_and_league_id
  	remove_index :items, name: :league_bo_with_bo
  	remove_index :items, :sockets

  	remove_index :item_mods, name: :item_mods_composite_1
  	remove_index :item_mods, name: :item_mods_composite_2
  	remove_index :item_mods, name: :item_mods_composite_3
  	remove_index :item_mods, name: :item_mods_composite_4
  	remove_index :item_mods, :id
  	remove_index :item_mods, :item_id_and_mod_id_and_total_value
  	remove_index :item_mods, :mod_id_and_item_id_and_total_value
  	remove_index :item_mods, :total_value_and_item_id_and_mod_id
  	remove_index :item_mods, :total_value_and_mod_id_and_item_id
  	remove_index :item_mods, name: :item_mods_mod_id_item_id_desc
  end
end
