class OrderNormalizedBuyoutIndex < ActiveRecord::Migration
  def change
    remove_index :items, column: :normalized_buyout
    add_index :items, :normalized_buyout, where: "buyout_amount <> 0", order: { normalized_buyout: :asc }
  end
end
