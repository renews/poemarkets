class CreateMods < ActiveRecord::Migration
  def change
    create_table :mods do |t|
      t.string :name
      t.boolean :explicit, default: true
      t.boolean :total, default: false

      t.index :explicit, where: "explicit = TRUE"
      t.index :total, where: "total = TRUE"
      t.index [:explicit, :total]
    end
  end
end
