class AddMoreIndexes < ActiveRecord::Migration
  def change
    add_index :items, [:league_id, :buyout_amount], where: "buyout_amount <> 0", name: :league_bo_with_bo
    add_index :items, [:league_id,  :shop_id]
    add_index :items, [:league_id,  :seller_id]
    add_index :items, [:league_id,  :buyout_currency_id]
    add_index :items, [:league_id,  :base_type_id]
    add_index :items, [:league_id,  :item_type_id]
    add_index :items, [:league_id,  :physical_dmg_min], order: { physical_dmg_min: :desc }
    add_index :items, [:league_id,  :physical_dmg_max], order: { physical_dmg_max: :desc }
    add_index :items, [:league_id,  :fire_dmg_min], order: { fire_dmg_min: :desc }
    add_index :items, [:league_id,  :fire_dmg_max], order: { fire_dmg_max: :desc }
    add_index :items, [:league_id,  :cold_dmg_min], order: { cold_dmg_min: :desc }
    add_index :items, [:league_id,  :cold_dmg_max], order: { cold_dmg_max: :desc }
    add_index :items, [:league_id,  :lightning_dmg_min], order: { lightning_dmg_min: :desc }
    add_index :items, [:league_id,  :lightning_dmg_max], order: { lightning_dmg_max: :desc }
    add_index :items, [:league_id,  :chaos_dmg_min], order: { chaos_dmg_min: :desc }
    add_index :items, [:league_id,  :chaos_dmg_max], order: { chaos_dmg_max: :desc }
    add_index :items, [:league_id,  :fire_dps], order: { fire_dps: :desc }
    add_index :items, [:league_id,  :cold_dps], order: { cold_dps: :desc }
    add_index :items, [:league_id,  :lightning_dps], order: { lightning_dps: :desc }
    add_index :items, [:league_id,  :chaos_dps], order: { chaos_dps: :desc }
    add_index :items, [:league_id,  :pdps], order: { pdps: :desc }
    add_index :items, [:league_id,  :edps], order: { edps: :desc }
    add_index :items, [:league_id,  :dps], order: { dps: :desc }
    add_index :items, [:league_id,  :block], order: { block: :desc }
    add_index :items, [:league_id,  :critical_strike_chance], order: { critical_strike_chance: :desc }
    add_index :items, [:league_id,  :attacks_per_second], order: { attacks_per_second: :desc }
    add_index :items, [:league_id,  :armour], order: { armour: :desc }
    add_index :items, [:league_id,  :evasion_rating], order: { evasion_rating: :desc }
    add_index :items, [:league_id,  :energy_shield], order: { energy_shield: :desc }
    add_index :items, [:league_id,  :item_level], order: { item_level: :desc }
    add_index :items, [:league_id,  :item_quantity], order: { item_quantity: :desc }
    add_index :items, [:league_id,  :required_level], order: { required_level: :desc }
    add_index :items, [:league_id,  :required_str], order: { required_str: :desc }
    add_index :items, [:league_id,  :required_dex], order: { required_dex: :desc }
    add_index :items, [:league_id,  :required_int], order: { required_int: :desc }
  end
end
