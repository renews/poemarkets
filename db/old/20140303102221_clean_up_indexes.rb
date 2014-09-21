class CleanUpIndexes < ActiveRecord::Migration
  def change
	remove_index :items, column: :created_at, name: :created_at_desc, order: { :created_at => :desc }
    add_index :items,  :buyout_amount
  end
end
