class AddItemLevelIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, [:item_level,:id], order: { item_level: :desc, id: :desc }
  end
end
