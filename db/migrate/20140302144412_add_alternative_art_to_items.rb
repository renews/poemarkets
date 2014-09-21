class AddAlternativeArtToItems < ActiveRecord::Migration
  def change
    add_column :items, :alternative_art, :boolean, default: false
    add_index :items, :alternative_art, where: "alternative_art = TRUE"
  end
end
