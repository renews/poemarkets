class CreateBaseTypes < ActiveRecord::Migration
  def change
    create_table :base_types do |t|
      t.string :name
      t.integer :item_type_id
      t.integer :required_str, default: 0
      t.integer :required_dex, default: 0
      t.integer :required_int, default: 0
      
      t.index :item_type_id
    end
  end
end
