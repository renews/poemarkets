class Addindexes6 < ActiveRecord::Migration
  def change
  	add_index :items, :num_sockets, name: :num_sockets_gt_1, where: "num_sockets >= 1"
  	add_index :items, :num_sockets, name: :num_sockets_gt_2, where: "num_sockets >= 2"
  	add_index :items, :num_sockets, name: :num_sockets_gt_3, where: "num_sockets >= 3"
  	add_index :items, :num_sockets, name: :num_sockets_gt_4, where: "num_sockets >= 4"
  	add_index :items, :num_sockets, name: :num_sockets_gt_5, where: "num_sockets >= 5"
  	add_index :items, :num_sockets, name: :num_sockets_gt_6, where: "num_sockets >= 6"
  end
end
