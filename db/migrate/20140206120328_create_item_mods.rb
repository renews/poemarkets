class CreateItemMods < ActiveRecord::Migration
  def change
    create_table :item_mods do |t|
      t.integer :item_id
      t.integer :mod_id
      t.integer :primary_value, default: 0
      t.integer :secondary_value, default: 0
      t.integer :total_value, default: 0
      
      t.index :item_id
      t.index :mod_id
    end
  end
end
