class Cleanindexes4 < ActiveRecord::Migration
  def change
  	add_index :item_mods, [:item_id, :mod_id, :total_value, :id], order: { total_value: :desc, id: :desc }
  	#add_index :items, [:num_sockets, :item_type_id, :league_id]
  	add_index :items, :dps, order: { dps: :desc }
  	add_index :items, :critical_strike_chance, order: { critical_strike_chance: :desc }
  	add_index :items, :num_sockets

  	remove_index :items, column: [:league_id, :id], order: { id: :desc }
  	remove_index :items, column: [:id, :league_id]

    remove_index :items, column: [:base_type_id, :id], order: { id: :desc }
    remove_index :items, column: [:item_type_id, :id], order: { id: :desc }
    remove_index :items, column: [:buyout_currency_id, :id], order: { id: :desc }
    remove_index :item_mods, column: [:mod_id, :total_value], name: :total_value_mod_id_desc, order: { total_value: :desc }
    remove_index :item_mods, column: [:mod_id, :total_value, :id], name: :total_value_mod_id_id_desc, order: { total_value: :desc, id: :desc }
    remove_index :item_mods, column: [:mod_id, :id], order: { id: :desc }
    remove_index :item_mods, column: [:item_id, :mod_id]
  end
end
