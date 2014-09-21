class AddIndexForItemType < ActiveRecord::Migration
  def change
    add_index :items, [:item_type_id, :league_id]
  end
end
