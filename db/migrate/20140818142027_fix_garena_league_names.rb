class FixGarenaLeagueNames < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE leagues SET name = 'Standard' WHERE name = 'Garena-Standard';
      UPDATE leagues SET name = 'Hardcore' WHERE name = 'Garena-Hardcore';
      UPDATE leagues SET name = 'One Month Race' WHERE name = 'Garena-One Month Race';
      UPDATE leagues SET name = 'One Month Race HC' WHERE name = 'Garena-One Month Race HC';
  	SQL
  end
end
