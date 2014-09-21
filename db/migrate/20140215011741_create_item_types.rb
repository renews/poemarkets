class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.string :family, default: 'Other'
      t.integer :order

      t.index :name
      t.index :family
    end
  end
end
