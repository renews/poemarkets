class MoreIndexes < ActiveRecord::Migration
  def change
    add_index :items, :updated_at
    add_index :shops, :last_indexed
    
    add_index :items, [:physical_dmg_min,:id], order: { physical_dmg_min: :desc, id: :desc }
    add_index :items, [:physical_dmg_max,:id], order: { physical_dmg_max: :desc, id: :desc }
    add_index :items, [:fire_dmg_min,:id], order: { fire_dmg_min: :desc, id: :desc }
    add_index :items, [:fire_dmg_max,:id], order: { fire_dmg_max: :desc, id: :desc }
    add_index :items, [:cold_dmg_min,:id], order: { cold_dmg_min: :desc, id: :desc }
    add_index :items, [:cold_dmg_max,:id], order: { cold_dmg_max: :desc, id: :desc }
    add_index :items, [:lightning_dmg_min,:id], order: { lightning_dmg_min: :desc, id: :desc }
    add_index :items, [:lightning_dmg_max,:id], order: { lightning_dmg_max: :desc, id: :desc }
    add_index :items, [:chaos_dmg_min,:id], order: { chaos_dmg_min: :desc, id: :desc }
    add_index :items, [:chaos_dmg_max,:id], order: { chaos_dmg_max: :desc, id: :desc }
    add_index :items, [:fire_dps,:id], order: { fire_dps: :desc, id: :desc }
    add_index :items, [:cold_dps,:id], order: { cold_dps: :desc, id: :desc }
    add_index :items, [:lightning_dps,:id], order: { lightning_dps: :desc, id: :desc }
    add_index :items, [:chaos_dps,:id], order: { chaos_dps: :desc, id: :desc }
    add_index :items, [:pdps,:id], order: { pdps: :desc, id: :desc }
    add_index :items, [:edps,:id], order: { edps: :desc, id: :desc }
    add_index :items, [:block,:id], order: { block: :desc, id: :desc }
    add_index :items, [:armour,:id], order: { armour: :desc, id: :desc }
    add_index :items, [:evasion_rating,:id], order: { evasion_rating: :desc, id: :desc }
    add_index :items, [:energy_shield,:id], order: { energy_shield: :desc, id: :desc }
  end
end
