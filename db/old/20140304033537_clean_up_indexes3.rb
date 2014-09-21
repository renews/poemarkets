class CleanUpIndexes3 < ActiveRecord::Migration
  def change
  	remove_index :items, column: [:id, :normalized_buyout],  name: :index_items_on_id_and_normalized_buyout, order: { normalized_buyout: :asc, id: :desc }
  	add_index :items, [:normalized_buyout, :id], where: "buyout_amount <> 0", order: { normalized_buyout: :asc, id: :desc }
  end
end
