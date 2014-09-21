class AddThreadIndexToShops < ActiveRecord::Migration
  def change
    add_index :shops, :thread
  end
end
