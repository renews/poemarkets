class AddLeagueIndex < ActiveRecord::Migration
  def change
  	add_index :items, [:league_id]
  end
end
