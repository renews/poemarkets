class Addindexes7 < ActiveRecord::Migration
  def change
  	add_index :items, [:critical_strike_chance,:id], order: { critical_strike_chance: :desc, id: :desc }
  	add_index :items, [:attacks_per_second,:id], order: { attacks_per_second: :desc, id: :desc }
  	add_index :items, [:num_sockets,:id], order: { num_sockets: :desc, id: :desc }
  	add_index :items, [:dps,:id], order: { dps: :desc, id: :desc }
  end
end
