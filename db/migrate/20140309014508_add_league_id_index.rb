class AddLeagueIdIndex < ActiveRecord::Migration
  def change
    add_index :items, [:id, :league_id], order: { id: :desc }
  end
end
