class Addindexes5 < ActiveRecord::Migration
  def change
  	add_index :items, [:league_id, :base_type_id, :item_type_id, :buyout_currency_id, :id], name: :composite_items_index, order: { id: :desc }
  end
end
