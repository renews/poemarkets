class AddNormalizedBuyoutToItems < ActiveRecord::Migration
  def change
    add_column :items, :normalized_buyout, :decimal, default: 0
    add_index :items, :normalized_buyout
    add_index :items, [:id, :normalized_buyout], order: { normalized_buyout: :asc, id: :desc }
  end
end
