class NewLeagueViews < ActiveRecord::Migration
  def change
  	execute <<-SQL
		CREATE VIEW one_month_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 9;
		CREATE VIEW one_month_hc_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 10;
		CREATE VIEW garena_one_month_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 11;
		CREATE VIEW garena_one_month_hc_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 12;
	
		DROP INDEX items_name_idx;
		CREATE INDEX items_name_idx ON items USING gist(name gist_trgm_ops)
	SQL
  end
end
