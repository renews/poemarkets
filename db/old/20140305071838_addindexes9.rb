class Addindexes9 < ActiveRecord::Migration
  def change
  	add_index :items, [:league_id, :physical_dmg_min,:id], order: { physical_dmg_min: :desc, id: :desc }
    add_index :items, [:league_id, :physical_dmg_max,:id], order: { physical_dmg_max: :desc, id: :desc }
    add_index :items, [:league_id, :fire_dmg_min,:id], order: { fire_dmg_min: :desc, id: :desc }
    add_index :items, [:league_id, :fire_dmg_max,:id], order: { fire_dmg_max: :desc, id: :desc }
    add_index :items, [:league_id, :cold_dmg_min,:id], order: { cold_dmg_min: :desc, id: :desc }
    add_index :items, [:league_id, :cold_dmg_max,:id], order: { cold_dmg_max: :desc, id: :desc }
    add_index :items, [:league_id, :lightning_dmg_min,:id], order: { lightning_dmg_min: :desc, id: :desc }
    add_index :items, [:league_id, :lightning_dmg_max,:id], order: { lightning_dmg_max: :desc, id: :desc }
    add_index :items, [:league_id, :chaos_dmg_min,:id], order: { chaos_dmg_min: :desc, id: :desc }
    add_index :items, [:league_id, :chaos_dmg_max,:id], order: { chaos_dmg_max: :desc, id: :desc }
    add_index :items, [:league_id, :fire_dps,:id], order: { fire_dps: :desc, id: :desc }
    add_index :items, [:league_id, :cold_dps,:id], order: { cold_dps: :desc, id: :desc }
    add_index :items, [:league_id, :lightning_dps,:id], order: { lightning_dps: :desc, id: :desc }
    add_index :items, [:league_id, :chaos_dps,:id], order: { chaos_dps: :desc, id: :desc }
    add_index :items, [:league_id, :pdps,:id], order: { pdps: :desc, id: :desc }
    add_index :items, [:league_id, :edps,:id], order: { edps: :desc, id: :desc }
    add_index :items, [:league_id, :block,:id], order: { block: :desc, id: :desc }
    add_index :items, [:league_id, :armour,:id], order: { armour: :desc, id: :desc }
    add_index :items, [:league_id, :evasion_rating,:id], order: { evasion_rating: :desc, id: :desc }
    add_index :items, [:league_id, :energy_shield,:id], order: { energy_shield: :desc, id: :desc }
    add_index :items, [:league_id, :critical_strike_chance,:id], order: { critical_strike_chance: :desc, id: :desc }
  	add_index :items, [:league_id, :attacks_per_second,:id], order: { attacks_per_second: :desc, id: :desc }
  	add_index :items, [:league_id, :num_sockets,:id], order: { num_sockets: :desc, id: :desc }
  	add_index :items, [:league_id, :dps,:id], order: { dps: :desc, id: :desc }
  end
end
