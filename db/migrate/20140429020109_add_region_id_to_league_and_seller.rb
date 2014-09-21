class AddRegionIdToLeagueAndSeller < ActiveRecord::Migration
  def change
  	add_column :leagues, :region_id, :integer, default: 1
  	add_column :sellers, :region_id, :integer, default: 1
  end
end
