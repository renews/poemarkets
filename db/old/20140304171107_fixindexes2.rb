class Fixindexes2 < ActiveRecord::Migration
  def change
    remove_index :item_mods, name: :total_value_desc
  end
end
