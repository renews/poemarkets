class DeleteOldViews < ActiveRecord::Migration
  def up
    execute <<-SQL
  		DROP VIEW ambush_items;
  		DROP VIEW invasion_items;
  		DROP VIEW garena_ambush_items;
  		DROP VIEW garena_invasion_items;
  	SQL
  end
end
