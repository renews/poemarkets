class AddAdditionalIndexes < ActiveRecord::Migration
  def change
    add_index :base_types, [:id, :name], order: { name: :asc }
    add_index :mods, [:id, :total, :name], order: { total: :desc, name: :asc }
  end
end
