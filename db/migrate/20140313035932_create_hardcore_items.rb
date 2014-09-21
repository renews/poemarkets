class CreateHardcoreItems < ActiveRecord::Migration
  def self.up
  	execute <<-SQL
  		CREATE VIEW hardcore_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 2 ORDER BY items.id DESC
  	SQL
  end

  def self.down
  	execute <<-SQL
  		DROP VIEW hardcore_items
  	SQL
  end
end
