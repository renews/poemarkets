class NewLeagueViews2 < ActiveRecord::Migration
  def change
  	execute <<-SQL
  	DROP VIEW one_month_items;
		DROP VIEW one_month_hc_items;
		DROP VIEW garena_one_month_items;
		DROP VIEW garena_one_month_hc_items;
  	
		CREATE VIEW one_month_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 11;
		CREATE VIEW one_month_hc_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 12;
		CREATE VIEW garena_one_month_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 13;
		CREATE VIEW garena_one_month_hc_items AS SELECT items.* FROM items INNER JOIN leagues ON items.league_id = leagues.id AND leagues.id = 14;
	
		DROP INDEX items_name_idx;
		CREATE INDEX items_name_idx ON items USING gist(name gist_trgm_ops)
	SQL
  end
end
