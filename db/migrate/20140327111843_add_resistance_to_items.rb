class AddResistanceToItems < ActiveRecord::Migration
  def change
    add_column :items, :fire_resistance, :integer, default: 0
    add_column :items, :cold_resistance, :integer, default: 0
    add_column :items, :lightning_resistance, :integer, default: 0
    add_column :items, :chaos_resistance, :integer, default: 0
    add_column :items, :all_resistance, :integer, default: 0
    add_column :items, :total_ele_resistance, :integer, default: 0
    add_column :items, :total_resistance, :integer, default: 0
    add_column :items, :num_ele_resistances, :integer, default: 0
    add_column :items, :num_resistances, :integer, default: 0
  end
end
