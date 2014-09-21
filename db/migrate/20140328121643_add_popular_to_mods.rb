class AddPopularToMods < ActiveRecord::Migration
  def change
    add_column :mods, :popular, :boolean, default: false
  end
end
