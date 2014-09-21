class CreateMatViews < ActiveRecord::Migration
  def change
    execute <<-SQL
  		DROP VIEW standard_items;
  		DROP VIEW hardcore_items;
  		DROP VIEW ambush_items;
  		DROP VIEW invasion_items;
  		CREATE VIEW standard_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 1;
  		CREATE VIEW hardcore_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 2;
  		CREATE VIEW ambush_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 3;
  		CREATE VIEW invasion_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 4;
  	SQL
  end
end
