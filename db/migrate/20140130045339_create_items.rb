class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :league_id
      t.integer :shop_id
      t.integer :seller_id
      t.string :name
      t.string :rarity
      t.integer :base_type_id
      t.integer :item_type_id
      t.decimal :buyout_amount, :precision => 8, :scale => 2, :default => 0
      t.integer :buyout_currency_id
      t.text :icon_url
      t.integer :w
      t.integer :h
      t.integer :quality, default: 0
      t.boolean :identified
      t.boolean :corrupted, :default => false
      t.integer :physical_dmg_min, :default => 0
      t.integer :physical_dmg_max, :default => 0
      t.integer :fire_dmg_min, :default => 0
      t.integer :fire_dmg_max, :default => 0
      t.integer :cold_dmg_min, :default => 0
      t.integer :cold_dmg_max, :default => 0
      t.integer :lightning_dmg_min, :default => 0
      t.integer :lightning_dmg_max, :default => 0
      t.integer :chaos_dmg_min, :default => 0
      t.integer :chaos_dmg_max, :default => 0
      t.decimal :fire_dps, :precision => 8, :scale => 2, :default => 0
      t.decimal :cold_dps, :precision => 8, :scale => 2, :default => 0
      t.decimal :lightning_dps, :precision => 8, :scale => 2, :default => 0
      t.decimal :chaos_dps, :precision => 8, :scale => 2, :default => 0
      t.decimal :pdps, :precision => 8, :scale => 2, :default => 0
      t.decimal :edps, :precision => 8, :scale => 2, :default => 0
      t.decimal :dps, :precision => 8, :scale => 2, :default => 0
      t.integer :block
      t.decimal :critical_strike_chance, :precision => 4, :scale => 2, :default => 0
      t.decimal :attacks_per_second, :precision => 4, :scale => 2, :default => 0
      t.integer :armour, :default => 0
      t.integer :evasion_rating, :default => 0
      t.integer :energy_shield, :default => 0
      t.integer :mana_multiplier, :default => 0
      t.string :mana_reserved, :default => 0
      t.integer :mana_cost, :default => 0
      t.string :cooldown_time
      t.string :item_desc
      t.text :description_text
      t.integer :item_level, :default => 0
      t.integer :item_quantity, :default => 0
      t.integer :required_level, :default => 0
      t.integer :required_str, :default => 0
      t.integer :required_dex, :default => 0
      t.integer :required_int, :default => 0
      t.string :sockets
      t.integer :num_sockets, :default => 0
      t.integer :s_sockets, :default => 0
      t.integer :d_sockets, :default => 0
      t.integer :i_sockets, :default => 0
      t.integer :w_sockets, :default => 0
      t.integer :links, :default => 0
      t.integer :s_links, :default => 0
      t.integer :d_links, :default => 0
      t.integer :i_links, :default => 0
      t.integer :w_links, :default => 0
      t.text :flavour_text
      t.timestamps
      
      t.index :shop_id
      t.index :seller_id
      t.index :buyout_currency_id
      #t.index :league_id
      t.index :base_type_id
      t.index :item_type_id
      t.index :physical_dmg_min
      t.index :physical_dmg_max
      t.index :fire_dmg_min
      t.index :fire_dmg_max
      t.index :cold_dmg_min
      t.index :cold_dmg_max
      t.index :lightning_dmg_min
      t.index :lightning_dmg_max
      t.index :chaos_dmg_min
      t.index :chaos_dmg_max
      t.index :fire_dps
      t.index :cold_dps
      t.index :lightning_dps
      t.index :chaos_dps
      t.index :pdps
      t.index :edps
      t.index :dps
      t.index :block
      t.index :critical_strike_chance
      t.index :attacks_per_second
      t.index :armour
      t.index :evasion_rating
      t.index :energy_shield
      t.index :item_level
      t.index :item_quantity
      t.index :required_level
      t.index :required_str
      t.index :required_dex
      t.index :required_int

      t.index :created_at
    end
  end
end
