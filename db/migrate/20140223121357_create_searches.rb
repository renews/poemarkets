class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :slug
      t.text :params
      t.timestamps
      
      t.index :slug, unique: true
    end
  end
end
