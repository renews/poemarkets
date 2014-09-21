class CleanUpIndex2 < ActiveRecord::Migration
  def change
    remove_index :items, column: [:id, :created_at], order: { created_at: :desc }
    remove_index :items, column: [:id, :league_id, :created_at], order: { created_at: :desc}
    remove_index :items, column: [:league_id, :created_at], order: { created_at: :desc }
    remove_index :items, column: [:base_type_id, :created_at], order: { created_at: :desc }
    remove_index :items, column: [:item_type_id, :created_at], order: { created_at: :desc }
    remove_index :items, column: [:buyout_currency_id, :created_at], order: { created_at: :desc }

    add_index :items, :id, order: { id: :desc }
    add_index :items, [:league_id, :id], order: { id: :desc }
    add_index :items, [:base_type_id, :id], order: { id: :desc }
    add_index :items, [:item_type_id, :id], order: { id: :desc }
    add_index :items, [:buyout_currency_id, :id], order: { id: :desc }
  end
end
