class AddStandardLeagueView < ActiveRecord::Migration
  def self.up
  	execute <<-SQL
  		CREATE VIEW standard_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 1 ORDER BY items.id DESC
  	SQL
  end

  def self.down
  	execute <<-SQL
  		DROP VIEW standard_items
  	SQL
  end
end
