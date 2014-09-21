class RemoveCrappyIndexes < ActiveRecord::Migration
  def change
      remove_index :items, column:  :physical_dmg_min
      remove_index :items, column:  :physical_dmg_max
      remove_index :items, column:  :fire_dmg_min
      remove_index :items, column:  :fire_dmg_max
      remove_index :items, column:  :cold_dmg_min
      remove_index :items, column:  :cold_dmg_max
      remove_index :items, column:  :lightning_dmg_min
      remove_index :items, column:  :lightning_dmg_max
      remove_index :items, column:  :chaos_dmg_min
      remove_index :items, column:  :chaos_dmg_max
      remove_index :items, column:  :fire_dps
      remove_index :items, column:  :cold_dps
      remove_index :items, column:  :lightning_dps
      remove_index :items, column:  :chaos_dps
      remove_index :items, column:  :pdps
      remove_index :items, column:  :edps
      remove_index :items, column:  :dps
      remove_index :items, column:  :block
      remove_index :items, column:  :critical_strike_chance
      remove_index :items, column:  :attacks_per_second
      remove_index :items, column:  :armour
      remove_index :items, column:  :evasion_rating
      remove_index :items, column:  :energy_shield
      remove_index :items, column:  :item_level
      remove_index :items, column:  :item_quantity
      remove_index :items, column:  :required_level
      remove_index :items, column:  :required_str
      remove_index :items, column:  :required_dex
      remove_index :items, column:  :required_int
	  remove_index :items, column:  [:league_id,  :shop_id]
	  remove_index :items, column:  [:league_id,  :seller_id]
	  remove_index :items, column:  [:league_id,  :buyout_currency_id]
	  remove_index :items, column:  [:league_id,  :base_type_id]
	  remove_index :items, column:  [:league_id,  :item_type_id]
	  remove_index :items, column:  [:league_id,  :physical_dmg_min], order: { physical_dmg_min: :desc }
	  remove_index :items, column:  [:league_id,  :physical_dmg_max], order: { physical_dmg_max: :desc }
	  remove_index :items, column:  [:league_id,  :fire_dmg_min], order: { fire_dmg_min: :desc }
	  remove_index :items, column:  [:league_id,  :fire_dmg_max], order: { fire_dmg_max: :desc }
	  remove_index :items, column:  [:league_id,  :cold_dmg_min], order: { cold_dmg_min: :desc }
	  remove_index :items, column:  [:league_id,  :cold_dmg_max], order: { cold_dmg_max: :desc }
	  remove_index :items, column:  [:league_id,  :lightning_dmg_min], order: { lightning_dmg_min: :desc }
	  remove_index :items, column:  [:league_id,  :lightning_dmg_max], order: { lightning_dmg_max: :desc }
	  remove_index :items, column:  [:league_id,  :chaos_dmg_min], order: { chaos_dmg_min: :desc }
	  remove_index :items, column:  [:league_id,  :chaos_dmg_max], order: { chaos_dmg_max: :desc }
	  remove_index :items, column:  [:league_id,  :fire_dps], order: { fire_dps: :desc }
	  remove_index :items, column:  [:league_id,  :cold_dps], order: { cold_dps: :desc }
	  remove_index :items, column:  [:league_id,  :lightning_dps], order: { lightning_dps: :desc }
	  remove_index :items, column:  [:league_id,  :chaos_dps], order: { chaos_dps: :desc }
	  remove_index :items, column:  [:league_id,  :pdps], order: { pdps: :desc }
	  remove_index :items, column:  [:league_id,  :edps], order: { edps: :desc }
	  remove_index :items, column:  [:league_id,  :dps], order: { dps: :desc }
	  remove_index :items, column:  [:league_id,  :block], order: { block: :desc }
	  remove_index :items, column:  [:league_id,  :critical_strike_chance], order: { critical_strike_chance: :desc }
	  remove_index :items, column:  [:league_id,  :attacks_per_second], order: { attacks_per_second: :desc }
	  remove_index :items, column:  [:league_id,  :armour], order: { armour: :desc }
	  remove_index :items, column:  [:league_id,  :evasion_rating], order: { evasion_rating: :desc }
	  remove_index :items, column:  [:league_id,  :energy_shield], order: { energy_shield: :desc }
	  remove_index :items, column:  [:league_id,  :item_level], order: { item_level: :desc }
	  remove_index :items, column:  [:league_id,  :item_quantity], order: { item_quantity: :desc }
	  remove_index :items, column:  [:league_id,  :required_level], order: { required_level: :desc }
	  remove_index :items, column:  [:league_id,  :required_str], order: { required_str: :desc }
	  remove_index :items, column:  [:league_id,  :required_dex], order: { required_dex: :desc }
	  remove_index :items, column:  [:league_id,  :required_int], order: { required_int: :desc }
	  remove_index :item_mods, column: [:mod_id, :item_id], order: { item_id: :desc }, name: :item_mods_mod_id_item_id_desc
  end
end
