class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :thread
      t.integer :seller_id
      t.datetime :last_updated
      t.datetime :last_indexed
      t.timestamps
      
      t.index :seller_id
      t.index :last_updated
      t.index :last_indexed
    end
  end
end
