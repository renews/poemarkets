class AddAccountIdToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :account_id, :integer
  end
end
