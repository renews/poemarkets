class AddIndexesToMatViews < ActiveRecord::Migration
  def change
    # add_index :standard_items, [:league_id, :id], order: { id: :desc }
    # add_index :standard_items, :base_type_id
    # add_index :standard_items, :item_type_id
    # add_index :standard_items, :seller_id
    # add_index :standard_items, :shop_id
    # add_index :standard_items, :normalized_buyout, where: "normalized_buyout > 0 OR buyout_currency_id IS NOT NULL", order: { normalized_buyout: :asc }
    # add_index :standard_items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :standard_one_h_item_type
    # add_index :standard_items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :standard_two_h_item_type
    # execute <<-SQL
    #   CREATE INDEX standard_items_name_idx ON standard_items USING gist(name gist_trgm_ops)
    # SQL
    
    # add_index :hardcore_items, [:league_id, :id], order: { id: :desc }
    # add_index :hardcore_items, :base_type_id
    # add_index :hardcore_items, :item_type_id
    # add_index :hardcore_items, :seller_id
    # add_index :hardcore_items, :shop_id
    # add_index :hardcore_items, :normalized_buyout, where: "normalized_buyout > 0 OR buyout_currency_id IS NOT NULL", order: { normalized_buyout: :asc }
    # add_index :hardcore_items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :hardcore_one_h_item_type
    # add_index :hardcore_items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :hardcore_two_h_item_type
    # execute <<-SQL
    #   CREATE INDEX hardcore_items_name_idx ON hardcore_items USING gist(name gist_trgm_ops)
    # SQL
    
    # add_index :ambush_items, [:league_id, :id], order: { id: :desc }
    # add_index :ambush_items, :base_type_id
    # add_index :ambush_items, :item_type_id
    # add_index :ambush_items, :seller_id
    # add_index :ambush_items, :shop_id
    # add_index :ambush_items, :normalized_buyout, where: "normalized_buyout > 0 OR buyout_currency_id IS NOT NULL", order: { normalized_buyout: :asc }
    # add_index :ambush_items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :ambush_one_h_item_type
    # add_index :ambush_items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :ambush_two_h_item_type
    # execute <<-SQL
    #   CREATE INDEX ambush_items_name_idx ON ambush_items USING gist(name gist_trgm_ops)
    # SQL
    
    # add_index :invasion_items, [:league_id, :id], order: { id: :desc }
    # add_index :invasion_items, :base_type_id
    # add_index :invasion_items, :item_type_id
    # add_index :invasion_items, :seller_id
    # add_index :invasion_items, :shop_id
    # add_index :invasion_items, :normalized_buyout, where: "normalized_buyout > 0 OR buyout_currency_id IS NOT NULL", order: { normalized_buyout: :asc }
    # add_index :invasion_items, [:item_type_id], where: "item_type_id IN(9,11,10,7,12,8,17)", name: :invasion_one_h_item_type
    # add_index :invasion_items, [:item_type_id], where: "item_type_id IN(14,16,15,6,13)", name: :invasion_two_h_item_type
    # execute <<-SQL
    #   CREATE INDEX invasion_items_name_idx ON invasion_items USING gist(name gist_trgm_ops)
    # SQL
  end
end
