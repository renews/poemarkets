class AddGarenaViews < ActiveRecord::Migration
  def change
  	execute <<-SQL
    	CREATE VIEW garena_standard_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 5;
		CREATE VIEW garena_hardcore_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 6;
		CREATE VIEW garena_ambush_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 7;
		CREATE VIEW garena_invasion_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 8;
	
		DROP INDEX items_name_idx;
		CREATE INDEX items_name_idx ON items USING gist(name gist_trgm_ops)
	SQL
  end
end
