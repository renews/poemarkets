class AddCraftedToIteMod < ActiveRecord::Migration
  def change
    add_column :item_mods, :crafted, :boolean, default: false
  end
end
