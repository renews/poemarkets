class AddIndexToQuality < ActiveRecord::Migration
  def change
    add_index :items, :quality
    add_index :items, :sockets
    add_index :items, :links
    add_index :items, :buyout_amount
    add_index :items, :identified, where: "identified = FALSE"
  end
end
