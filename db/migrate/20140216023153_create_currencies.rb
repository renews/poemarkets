class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :alternate_names
      t.text :icon_url

      t.index :name
    end
  end
end
