class CreateInvasionItems < ActiveRecord::Migration
  def self.up
  	execute <<-SQL
  		CREATE VIEW invasion_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 4 ORDER BY items.id DESC
  	SQL
  end

  def self.down
  	execute <<-SQL
  		DROP VIEW invasion_items
  	SQL
  end
end
