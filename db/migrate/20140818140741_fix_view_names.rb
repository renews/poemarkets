class FixViewNames < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER VIEW one_month_hc_items RENAME TO global_one_month_race_hc_items;
    	ALTER VIEW one_month_items RENAME TO global_one_month_race_items;
    	ALTER VIEW garena_one_month_hc_items RENAME TO garena_one_month_hc_race_items;
    	ALTER VIEW garena_one_month_items RENAME TO garena_one_month_race_items;
    	ALTER VIEW standard_items RENAME TO global_standard_items;
    	ALTER VIEW hardcore_items RENAME TO global_hardcore_items;
  	SQL
  end
end
