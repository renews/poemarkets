class Cleanupindexes5 < ActiveRecord::Migration
  def change
  	add_index :item_mods, [:item_id, :mod_id]
  end
end
