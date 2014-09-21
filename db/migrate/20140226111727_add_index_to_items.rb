class AddIndexToItems < ActiveRecord::Migration
  def change
    change_table :items do |t|
      t.index [:league_id, :id], order: { id: :desc }
    end
  end
end
