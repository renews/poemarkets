class Fixindexes3 < ActiveRecord::Migration
  def change
    add_index :item_mods, [:mod_id, :total_value], order: { total_value: :desc }
    add_index :item_mods, [:mod_id, :item_id]
    add_index :items, [:league_id, :item_type_id]
  end
end
