class Addindexes8 < ActiveRecord::Migration
  def change
  	add_index :items, :name
  	add_index :items, :quality
  end
end
