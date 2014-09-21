class CreateResistanceMods < ActiveRecord::Migration
  def change
    create_table :resistance_mods do |t|
      t.string :name
    end
  end
end
