class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :uuid
      t.string :account_name
      t.string :ign, :default => '**Pending**'
      t.string :challenge_icon
      t.boolean :online, default: false
      t.datetime :online_until
      t.string :steam_name
      t.string :steam_id
      t.timestamps
      
      t.index :uuid, :unique => true
      t.index :account_name
      t.index :steam_name
      t.index :steam_id
      t.index :online
      t.index :online_until
    end
  end
end
