class CreateAmbushItems < ActiveRecord::Migration
  def self.up
  	execute <<-SQL
  		CREATE VIEW ambush_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 3 ORDER BY items.id DESC
  	SQL
  end

  def self.down
  	execute <<-SQL
  		DROP VIEW ambush_items
  	SQL
  end
end
