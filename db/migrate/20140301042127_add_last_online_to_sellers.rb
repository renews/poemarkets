class AddLastOnlineToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :last_seen_online, :datetime
    add_index :sellers, :last_seen_online
  end
end
