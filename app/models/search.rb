class Search < ActiveRecord::Base
  def find_items(page, league)
    @items ||= query_items(page, league)
  end
  
  def query_items(page, league)
    page = 1 if page.nil? or page < 1
    @chaos = Currency.find_by_name('Chaos Orb')
    params = JSON.parse self.params
    if league
      items = Item.from("#{league.view_name} as items")
    else
      items = Item.where(league: League.find_by_name('Standard'))
    end
    items = items.where("LOWER(items.name) LIKE ?", '%'+params["name"].downcase+'%').references(:items) if params["name"].present?
    items = items.where("identified = FALSE") if params["unidentified"].present?
    items = items.where("items.base_type_id = ?", params["base"]).references(:items) if params["base"].present?
    item_type = params["item_type"].split(',').map! {|i| i.to_i} if params["item_type"].present?
    if item_type and item_type.count > 1
    items = items.where("items.item_type_id IN (?)", item_type).references(:items)
    elsif item_type
    items = items.where("items.item_type_id = ?", item_type).references(:items)
    end
    
    items = items.where("(physical_dmg_min+fire_dmg_min+cold_dmg_min+lightning_dmg_min+chaos_dmg_min) >= ?", params["min_dmg"].to_i) if params["min_dmg"].present?
    items = items.where("(physical_dmg_max+fire_dmg_max+cold_dmg_max+lightning_dmg_max+chaos_dmg_max) <= ?", params["max_dmg"].to_i) if params["max_dmg"].present?
    items = items.where("pdps >= ?", params["pdps_min"].to_f) if params["pdps_min"].present?
    items = items.where("pdps <= ?", params["pdps_max"].to_f) if params["pdps_max"].present?
    items = items.where("edps >= ?", params["edps_min"].to_f) if params["edps_min"].present?
    items = items.where("edps <= ?", params["edps_max"].to_f) if params["edps_max"].present?
    items = items.where("dps >= ?", params["dps_min"].to_f) if params["dps_min"].present?
    items = items.where("dps <= ?", params["pdps_max"].to_f) if params["dps_max"].present?
    items = items.where("attacks_per_second >= ?", params["aps_min"].to_f) if params["aps_min"].present?
    items = items.where("attacks_per_second <= ?", params["aps_max"].to_f) if params["aps_max"].present?
    items = items.where("critical_strike_chance >= ?", params["crit_min"].to_f) if params["crit_min"].present?
    items = items.where("critical_strike_chance <= ?", params["crit_max"].to_f) if params["crit_max"].present?
    items = items.where("armour >= ?", params["armour_min"].to_i) if params["armour_min"].present?
    items = items.where("armour <= ?", params["armour_max"].to_i) if params["armour_max"].present?
    items = items.where("evasion_rating >= ?", params["evasion_min"].to_i) if params["evasion_min"].present?
    items = items.where("evasion_rating <= ?", params["evasion_max"].to_i) if params["evasion_max"].present?
    items = items.where("energy_shield >= ?", params["shield_min"].to_i) if params["shield_min"].present?
    items = items.where("energy_shield <= ?", params["shield_min"].to_i) if params["shield_max"].present?
    items = items.where("block >= ?", params["block_min"].to_i) if params["block_min"].present?
    items = items.where("block <= ?", params["block_max"].to_i) if params["block_max"].present?
    items = items.where("num_sockets >= ?", params["sockets_min"].to_i) if params["sockets_min"].present?
    items = items.where("num_sockets <= ?", params["sockets_max"].to_i) if params["sockets_max"].present?
    items = items.where("links >= ?", params["links_min"].to_i) if params["links_min"].present?
    items = items.where("links <= ?", params["links_max"].to_i) if params["links_max"].present?
    items = items.where("s_sockets >= ?", params["s_sockets"].to_i) if params["s_sockets"].present?
    items = items.where("d_sockets >= ?", params["d_sockets"].to_i) if params["d_sockets"].present?
    items = items.where("i_sockets >= ?", params["i_sockets"].to_i) if params["i_sockets"].present?
    items = items.where("w_sockets >= ?", params["w_sockets"].to_i) if params["w_sockets"].present?
    items = items.where("s_links >= ?", params["s_links"].to_i) if params["s_links"].present?
    items = items.where("d_links >= ?", params["d_links"].to_i) if params["d_links"].present?
    items = items.where("i_links >= ?", params["i_links"].to_i) if params["i_links"].present?
    items = items.where("w_links >= ?", params["w_links"].to_i) if params["w_links"].present?
    items = items.where("required_level >= ?", params["required_level_min"].to_i) if params["required_level_min"].present?
    items = items.where("required_level <= ?", params["required_level_max"].to_i) if params["required_level_max"].present?
    items = items.where("required_str >= ?", params["required_str_min"].to_i) if params["required_str_min"].present?
    items = items.where("required_str <= ?", params["required_str_max"].to_i) if params["required_str_max"].present?
    items = items.where("required_dex >= ?", params["required_dex_min"].to_i) if params["required_dex_min"].present?
    items = items.where("required_dex <= ?", params["required_dex_max"].to_i) if params["required_dex_max"].present?
    items = items.where("required_int >= ?", params["required_int_min"].to_i) if params["required_int_min"].present?
    items = items.where("required_int <= ?", params["required_int_max"].to_i) if params["required_int_max"].present?
    items = items.where("quality >= ?", params["quality_min"].to_i) if params["quality_min"].present?
    items = items.where("quality <= ?", params["quality_max"].to_i) if params["quality_max"].present?
    items = items.where("item_quantity >= ?", params["item_quantity_min"].to_i) if params["item_quantity_min"].present?
    items = items.where("item_quantity <= ?", params["item_quantity_max"].to_i) if params["item_quantity_max"].present?
    items = items.where("item_level >= ?", params["item_level_min"].to_i) if params["item_level_min"].present?
    items = items.where("item_level <= ?", params["item_level_max"].to_i) if params["item_level_max"].present?
    items = items.where("rarity = ?", params["rarity"]) if params["rarity"].present?
    
    # Resistances
    items = items.where("fire_resistance >= ?", params["fire_resistance_min"]) if params["fire_resistance_min"].present?
    items = items.where("cold_resistance >= ?", params["cold_resistance_min"]) if params["cold_resistance_min"].present?
    items = items.where("lightning_resistance >= ?", params["lightning_resistance_min"]) if params["lightning_resistance_min"].present?
    items = items.where("chaos_resistance >= ?", params["chaos_resistance_min"]) if params["chaos_resistance_min"].present?
    items = items.where("total_ele_resistance >= ?", params["total_ele_resistance_min"]) if params["total_ele_resistance_min"].present?
    items = items.where("total_resistance >= ?", params["total_resistance_min"]) if params["total_resistance_min"].present?
    items = items.where("num_ele_resistances >= ?", params["num_ele_resistances_min"]) if params["num_ele_resistances_min"].present?
    items = items.where("num_resistances >= ?", params["num_resistances_min"]) if params["num_resistances_min"].present?
    
    
      # Misc
      items = items.joins("INNER JOIN sellers ON items.seller_id = sellers.id").where("sellers.online = TRUE").references(:sellers) if params["online_only"] == 'yes'
      items = items.where("alternative_art = TRUE") if params["alternative_art"] == 'yes'
      items = items.where("corrupted = TRUE") if params["corrupted"] == 'yes'
      items = items.joins("INNER JOIN sellers ON items.seller_id = sellers.id").where("sellers.account_name ILIKE ?", params["seller_name"]) if params["seller_name"].present?
      items = items.joins("INNER JOIN shops ON items.shop_id = shops.id").where("shops.thread = ?", params["thread_no"]).references(:shops) if params["thread_no"].present?
      
      # Buyout
      items = items.where("normalized_buyout > 0 OR buyout_currency_id IS NOT NULL") if params["only_with_buyout"] == 'yes'
      
      if params["buyout_amount"].present? and params["buyout_currency"].present? and params["normalize_buyouts"] == 'yes'
        currency_ratio = CurrencyRatio.where(league_id: League.find_by_name(params["league"]), currency_id: params["buyout_currency"].to_i).first.chaos_ratio
        items = items.where("(normalized_buyout > 0 OR buyout_currency_id IS NOT NULL) AND normalized_buyout <= ?", params["buyout_amount"].to_f / currency_ratio)
      else
        items = items.where("buyout_amount <= ?", params["buyout_amount"].to_f) if params["buyout_amount"].present?
        items = items.where("buyout_currency_id = ?", params["buyout_currency"].to_i) if params["buyout_currency"].present? and (params["buyout_currency"].to_i != @chaos.id or params["buyout_amount"].present?)
      end
    
    # Ordering
    imp_order_mod = false
    exp_order_mod = false
    order_mod = false
    order = false
    if params["order"] and !params["order"].blank?
      unless params["order"].include?('exmod-') or params["order"].include?('impmod-')
        if params["order"] == 'gem_level'
          select_order = "item_level"
          order = select_order + " DESC"
          items = items.where("item_type_id = ?", ItemType.find_by_name('Gem').id)
        elsif params["order"] == 'map_level'
          select_order = "item_level"
          order = select_order + " DESC"
          items = items.where("item_type_id = ?", ItemType.find_by_name('Map').id)
        elsif params["order"] == 'buyout_amount'
          select_order = "normalized_buyout"
          order = select_order + " ASC"
          items = items.where('normalized_buyout > 0 OR buyout_currency_id IS NOT NULL') unless params["only_with_buyout"] == 'yes'
        else
          select_order = params['order']
          order = select_order + " DESC"
        end
      else
        imp_order_mod = true if params["order"].include?('impmod-')
        exp_order_mod = true if params["order"].include?('exmod-')
        order_mod = params["order"].sub('impmod-', '').sub('exmod-', '')
      end
    end
    
    # Implicit Mod
    mods_included = false
    join_clause = ''
    unless params["implicit_mod"].blank?
      exists = " EXISTS(SELECT implicit_mod.id FROM item_mods implicit_mod WHERE implicit_mod.item_id = items.id"
      exists += ' AND implicit_mod.mod_id = ' + params['implicit_mod']
      exists += " AND implicit_mod.total_value >= #{params['implicit_primary_value_min']}" unless params["implicit_primary_value_min"].blank?
      exists += " AND implicit_mod.total_value <= #{params['implicit_primary_value_max']}" unless params["implicit_primary_value_max"].blank?
      exists += " LIMIT 1)"
      mods_included = true
      items = items.where(exists)
    end
    
    # Explicit Mods
    explicit_mods = Hash.new
    if params["explicit_mods"]
      explicit_mods = params["explicit_mods"]
     end
    
    explicit_mods.reject! { |i, m| m.empty? } unless explicit_mods.empty?
    
    unless explicit_mods.empty?
      explicit_mods.each_pair do |index, mod|
          exists = " EXISTS(SELECT explicit_mod_#{mod}.id FROM item_mods explicit_mod_#{mod} WHERE explicit_mod_#{mod}.item_id = items.id AND explicit_mod_#{mod}.mod_id = #{mod}"
          exists += " AND explicit_mod_#{mod}.total_value >= #{params['primary_value_min'][index]}" unless params["primary_value_min"][index].blank?
          exists += " AND explicit_mod_#{mod}.total_value <= #{params['primary_value_max'][index]}" unless params["primary_value_max"][index].blank?
          exists += " LIMIT 1)"
          mods_included = true
          items = items.where(exists)
      end
    end
    

    items = items.select('items.id AS found_items_id')


    items = items.limit(10).offset(10*(page-1))
    
    if order
      items = items.order(order)
    end
    if order_mod
      if imp_order_mod
        join_clause += " INNER JOIN item_mods implicit_mod_order ON implicit_mod_order.item_id = items.id AND implicit_mod_order.mod_id = #{order_mod} "
        items = items.select("implicit_mod_order.total_value").order('implicit_mod_order.total_value DESC')
      end
      if exp_order_mod
        join_clause += " INNER JOIN item_mods explicit_mod_#{order_mod}_order ON explicit_mod_#{order_mod}_order.item_id = items.id AND explicit_mod_#{order_mod}_order.mod_id = #{order_mod} "
        items = items.select("explicit_mod_#{order_mod}_order.total_value").order("explicit_mod_#{order_mod}_order.total_value DESC")
      end
    end
    items = items.order("items.id DESC").references(:items) unless order or order_mod
    items = items.joins(join_clause) unless join_clause.blank?
    ids = items.map { |i| i.found_items_id }
    ids_join = ids.join(',')
    found_items = Item.includes(:base_type, :item_type, :item_mods, :mods, :shop, :seller).where("items.id IN (?)", ids).order("POSITION(items.id::text IN '(#{ids_join})')").references(:items)
    found_items
  end
end
