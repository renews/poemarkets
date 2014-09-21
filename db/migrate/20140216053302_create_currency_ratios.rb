class CreateCurrencyRatios < ActiveRecord::Migration
  def change
    create_table :currency_ratios do |t|
      t.integer :league_id
      t.integer :currency_id
      t.decimal :chaos_ratio
      t.timestamps
      
      t.index :league_id
      t.index :currency_id
    end
  end
end
