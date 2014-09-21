class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :url
      t.integer :league_id
    end
  end
end
