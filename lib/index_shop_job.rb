require 'open-uri'
require 'nokogiri'
require 'json'
require 'time'
require 'uri'
require 'destroy_shop_job'
require 'le_logger'

class IndexShopJob
  include Resque::Plugins::UniqueJob
  
  @queue = :index_queue
	def self.perform(shop_id)
	  begin
		  shop = Shop.find(shop_id)
	  rescue ActiveRecord::RecordNotFound
	    LOGGER.info "Shop with ID #{shop_id} no longer available"
	    return
    end
		
		# If shop hasn't been updated in a long time, remove it and continue
    if shop.last_updated < 2.weeks.ago then
      Resque.enqueue(DestroyShopJob, shop.id) unless shop.id.nil?
      return true
    end
		
		# Open the shop url
		begin
			uri = URI.parse(shop.thread)
			garena = uri.host.include?('garena') ? true : false
			site = open(shop.thread)
		rescue OpenURI::HTTPError => e
			shop.destroy if e.message.include?('404')
			return true
		end

		@result = Nokogiri::HTML(site)

		# Find shop global buyout, if exists
		buyout = @result.xpath('//div[@class="content"]').first.content.strip.sub(',','.').scan(/.*?(~gb\/o)(\s+)(\d+(\.\d*)?|\.\d+)(\s+)((?:[a-zA-Z][a-zA-Z]+))/)
		unless buyout.empty?
			item_buyout = []
			item_buyout[0] = buyout[0][2].strip.to_f
			item_buyout[1] = self.buyout_currency(buyout[0][5].to_s.strip.downcase)
			global_buyout = item_buyout
		end

		# Select item data
	  	script = @result.css('script').last
	  	string = script.content.to_s.strip
	  
	  	# Remove the JSON we are interested in
	  	start_index = string.index('new R(')
    	end_index = string.index(')).run()')
    	if start_index and end_index
	  	  json = string.slice((start_index+6)..end_index-1)
	  	else # Shop has no items
	  	  shop.items.destroy_all unless shop.items.empty?
	  	  shop.last_indexed = Time.now
	  	  shop.save
	  	  return true
  	  end
	  
	  	# Parse the JSON
	  	items_json = JSON.parse(json)
	  	
		  # Loop through each item, adding it to the index
		  
		  new_items = []
		  added_items = []
		  ActiveRecord::Base.transaction do
		  items_json.each do |item|
		  	item_index = item[0]
		  	item = item[1]
		  	
		  	next if item["league"] == 'Unknown' or item["league"] == 'Void'
		  	
		  	@new_item = Item.new
		  	item["league"] = 'Garena-'+item['league'] if garena
		  	@new_item.league = League.find_by_name(item["league"])
		  	if @new_item.league.nil?
		  	  LOGGER.info "Unknown League #{item['league']} -- skipped"
		  	  next
	  	  end
		  	
		  	# Check item individual buyout
		  	buyout = self.check_item_tag(item_index)
		  	unless buyout then
		  	  # Check spoiler tag buyout
		  	  buyout = self.check_spoiler_tag(item_index)
		  	  unless buyout then
		  	    # Use global buyout, if exists
		  	    buyout = global_buyout if global_buyout
	  	    end
	  	  end
		  	
		  	if buyout and buyout[1]
		  	  if buyout[0] > 1000000 # Some stupid b/o amount
		  	    next
	  	    end
	  	    @new_item.buyout_amount = buyout[0]
	  	    @new_item.buyout_currency = buyout[1]
	  	    begin
	  	      currency_ratio = CurrencyRatio.where(league_id: @new_item.league.id, currency_id: @new_item.buyout_currency.id).first.chaos_ratio
  	      rescue
  	        LOGGER.info "Unknown Currency Ratio #{item['league']} currency #{@new_item.buyout_currency.name} -- skipped"
  		  	  next
	        end
	  	    @new_item.normalized_buyout = @new_item.buyout_amount/currency_ratio
  	    end
  	    
  	    # Stop unverified items
		  	next unless item["verified"] or (buyout and buyout[1] and buyout[1].name == 'Mirror of Kalandra')
  	    
  	    # Stop duplicates within the same shop
  	    #item['buyout_amount'] = @new_item.buyout_amount
  	    #item['buyout_currency'] = @new_item.buyout_currency_id
		  	#next if new_items.include?(item)
		  	#new_items << item
		  	
		  	@new_item.shop = shop
		  	@new_item.seller = shop.seller
		  	@new_item.name = item["name"]
		  	@new_item.name = item['typeLine'] if @new_item.name.blank?
		  	@new_item.w = item["w"]
		  	@new_item.h = item["h"]
		  	@new_item.icon_url = item["icon"]
		  	
		  	# Check if alternate art
		  	icon_uri = URI.parse(@new_item.icon_url)
		  	@new_item.alternative_art = true if File.basename(icon_uri.path).downcase.include?('alt')
		  	
		  	@new_item.rarity = item["frameType"]
		  	@new_item.identified = item["identified"] unless item["identified"].nil?
		  	@new_item.corrupted = item["corrupted"] unless item["corrupted"].nil?
		  	@new_item.description_text = item["secDescrText"] if item["secDescrText"]
		  	#@new_item.flavour_text = item["flavourText"][0] if item["flavourText"]
		  	
		  	base = item["typeLine"]
		  	next if base.include?('Imprint') or base.include?('Fishing Rod')
		  	@new_item.base_type = BaseType.find_by_name(base)
		  	if @new_item.base_type.nil?
	  	    BaseType.all.each do |type|
	  	      @new_item.base_type = type if base.downcase.match(/\b#{type.name.downcase}\b/)
  	      end
  	    end
  	    
  	    if @new_item.base_type.nil?
          LOGGER.info "Unknown base type: #{base} -- skipped"
          next 
  	    end
  	    
  	    if !@new_item.base_type.nil? and @new_item.base_type.item_type.nil?
  	      p "Unknown item type for base type: #{base} -- skipped"
  	      next
	      end
  	    
  	    @new_item.item_type = @new_item.base_type.item_type
		  	
		  	if item["properties"] then
		  		properties = item["properties"]
		  		properties.each do |property|
			  		case property["name"]
			  			when "Armour" then
			  				armour = property["values"][0][0]
			  				@new_item.armour = armour
			  		  when "Evasion Rating" then
			  		  	eva = property["values"][0][0]
			  		  	@new_item.evasion_rating = eva
			  		  when "Energy Shield" then
			  		  	eng = property["values"][0][0]
			  		  	@new_item.energy_shield = eng
			  		  when "Chance to Block" then
			  		    cb = property["values"][0][0].sub('%', '')
			  		    @new_item.block = cb
					  	when "Physical Damage" then
					  		phys_dmg = property["values"][0][0].split('-')
					  		@new_item.physical_dmg_min = phys_dmg[0]
					  		@new_item.physical_dmg_max = phys_dmg[1]
					  	when "Elemental Damage" then
					  		property["values"].each do |value|
					  			ele_dmg = value[0].split('-')
					  			case value[1]
					  				when 4 then #Fire damage
					  					@new_item.fire_dmg_min = ele_dmg[0]
					  					@new_item.fire_dmg_max = ele_dmg[1]
					  				when 5 then #Cold damage
					  					@new_item.cold_dmg_min = ele_dmg[0]
					  					@new_item.cold_dmg_max = ele_dmg[1]
					  				when 6 then #Lightning damage
					  					@new_item.lightning_dmg_min = ele_dmg[0]
					  					@new_item.lightning_dmg_max = ele_dmg[1]
					  			end
					  		end
					  	when "Chaos Damage" then
					  		chaos_dmg = property["values"][0][0].split('-')
					  		@new_item.chaos_dmg_min = chaos_dmg[0]
					  		@new_item.chaos_dmg_max = chaos_dmg[1]
					  	when "Critical Strike Chance" then
					  		crit = property["values"][0][0].sub('%', '')
					  		@new_item.critical_strike_chance = crit
					  	when "Attacks per Second" then
					  		aps = property["values"][0][0].to_f
					  		@new_item.attacks_per_second = aps
	
    				  	# Calculate DPS
    				  	physical_dps = 0
    				  	fire_dps = 0
    				  	cold_dps = 0
    				  	lightning_dps = 0
    				  	chaos_dps = 0
    				  	
    				  	physical_dps = ((@new_item.physical_dmg_min+@new_item.physical_dmg_max) / 2)*aps unless @new_item.physical_dmg_min.blank?
    				  	fire_dps = ((@new_item.fire_dmg_min+@new_item.fire_dmg_max) / 2)*aps unless @new_item.fire_dmg_min.blank?
    				  	cold_dps = ((@new_item.cold_dmg_min+@new_item.cold_dmg_max)  / 2)*aps unless @new_item.cold_dmg_min.blank?
    				  	lightning_dps = ((@new_item.lightning_dmg_min+@new_item.lightning_dmg_max) / 2)*aps unless @new_item.lightning_dmg_min.blank?
    				  	chaos_dps = ((@new_item.chaos_dmg_min+@new_item.chaos_dmg_max) / 2)*aps unless @new_item.chaos_dmg_min.blank?
    				  	@new_item.fire_dps = fire_dps
    				  	@new_item.cold_dps = cold_dps
    				  	@new_item.lightning_dps = lightning_dps
    				  	@new_item.chaos_dps = chaos_dps
    				  	@new_item.edps = fire_dps+cold_dps+lightning_dps
    				  	@new_item.pdps = physical_dps
    				  	@new_item.dps = @new_item.pdps+@new_item.edps
					  	when "Level" then
					  		lvl = property["values"][0][0]
					  		@new_item.item_level = lvl
					  	when "Mana Cost" then
					  	  mc = property["values"][0][0]
					  	  @new_item.mana_cost = mc
					  	when "Mana Multiplier" then
					  		mm = property["values"][0][0].sub('%', '')
					  		@new_item.mana_multiplier = mm
					  	when "Mana Reserved" then
					  		mr = property["values"][0][0]
					  		@new_item.mana_reserved = mr
					  	when "Cooldown Time" then
					  		cd = property["values"][0][0].sub(' sec', '')
					  		@new_item.cooldown_time = cd
					  	when "Quality" then
					  		qu = property["values"][0][0].sub('+', '').sub('%', '')
					  		@new_item.quality = qu
					  	when "Map Level" then
					  	  ml = property["values"][0][0]
					  	  @new_item.item_level = ml
				  	  when "Item Quantity" then
				  	    iq = property["values"][0][0].sub('+', '').sub('%', '')
				  	    @new_item.item_quantity = iq
					  	else
					  		if property["values"].empty? then
					  			@new_item.item_desc = property["name"]
					  		end
				  	end
		  		end      
		  	end

		  	# Fix maps that have gem names within them
  	    	@new_item.item_type = ItemType.find_by_name('Map') if @new_item.item_type.name == 'Gem' and @new_item.item_level > 30

		  	if item["requirements"] then
	  			requirements = item["requirements"]
	  			requirements.each do |requirement|
	  				case requirement["name"]
	  				when "Level" then
	  					@new_item.required_level = requirement["values"][0][0]
	  				when "Str" then
	  				  @new_item.required_str = @new_item.base_type.required_str
	  					@new_item.required_str = requirement["values"][0][0] if @new_item.required_str.blank? 
	  				when "Dex" then
	  				  @new_item.required_dex = @new_item.base_type.required_dex
	  					@new_item.required_dex = requirement["values"][0][0] if @new_item.required_dex.blank? 
	  				when "Int" then
	  				  @new_item.required_int = @new_item.base_type.required_int
	  					@new_item.required_int = requirement["values"][0][0] if @new_item.required_int.blank? 
	  				end
	  			end
	  		end
	  		if item["sockets"] and !item["sockets"].empty? then
	  			socket_string = ''
	  			s_sockets = 0
	  			d_sockets = 0
	  			i_sockets = 0
	  			w_sockets = 0
	  			s_links = 0
	  			d_links = 0
	  			i_links = 0
	  			w_links = 0
	  			links = 0
	  			max_links = 0
	  			socket_group = item["sockets"][0]
	  			item["sockets"].each_with_index do |socket, index|
	  			if socket_group["group"] == socket["group"] then # Socket group same, must be linked
	  						socket_string += '-' if index != 0
	  						links += 1
	  						max_links += 1 if links >= max_links
      	  			case socket["attr"]
        				    when 'S' then
        				      s_links += 1
      				      when 'D' then
      				        d_links += 1
      			        when 'I' then
      			          i_links += 1
      		          when 'G' then
      		            w_links += 1
        				end
	  				else
	  						socket_string += ' ' if index != 0
	  						links = 0
	  				end
	  				socket_string += socket["attr"]
	  				case socket["attr"]
  				    when 'S' then
  				      s_sockets += 1
				      when 'D' then
				        d_sockets += 1
			        when 'I' then
			          i_sockets += 1
		          when 'G' then
		            w_sockets += 1
  				  end
	  				socket_group["group"] = socket["group"]
	  				socket_color = socket["attr"]
	  			end
	  			@new_item.sockets = socket_string
	  			@new_item.s_sockets = s_sockets
	  			@new_item.d_sockets = d_sockets
	  			@new_item.i_sockets = i_sockets
	  			@new_item.w_sockets = w_sockets
	  			@new_item.s_links = s_links
	  			@new_item.d_links = d_links
	  			@new_item.i_links = i_links
	  			@new_item.w_links = w_links
	  			@new_item.links = max_links
	  			@new_item.num_sockets = item["sockets"].length
	  		end
        
        @new_item.save
        
        # Mods
        @new_item_mods = []
        self.record_mods(item)
        ItemMod.import(@new_item_mods)
        
        # Check for existing identical item in shop
        existing_item = Item.where(
	  		  league: @new_item.league,
	  		  shop: @new_item.shop,
	  		  seller: @new_item.seller,
	  		  name: @new_item.name,
	  		  icon_url: @new_item.icon_url,
	  		  item_type: @new_item.item_type,
	  		  base_type: @new_item.base_type,
	  		  rarity: @new_item.rarity.to_s,
	  		  sockets: @new_item.sockets,
	  		  armour: @new_item.armour,
	  		  evasion_rating: @new_item.evasion_rating,
	  		  energy_shield: @new_item.energy_shield,
	  		  dps: @new_item.dps,
	  		  corrupted: @new_item.corrupted
	  		).where.not(id: @new_item.id).first
	  		if existing_item
	  		  # Check mods
	  		  same_mods = true
	  		  existing_item.item_mods.each do |item_mod|
            existing_item_mod = ItemMod.where(mod: item_mod, item: @new_item, primary_value: item_mod.primary_value, secondary_value: item_mod.secondary_value).first
            if existing_item_mod.nil?
              same_mods = false
            end
  		    end
  		    if same_mods
	  		    if item["verified"]
  	  		    existing_item.updated_at = Time.now
  	  		    existing_item.buyout_amount = @new_item.buyout_amount
  	  		    existing_item.buyout_currency = @new_item.buyout_currency
  	  		    existing_item.normalized_buyout = @new_item.normalized_buyout
  	  		    existing_item.save
  	  		    added_items << existing_item
    		    else
    		      existing_item.destroy
  		      end
  		      @new_item.destroy
  		      next
		      end
		    end
        
        # Resistances
        @new_item.resistance_mods.each do |mod|
          case mod.mod.name
          when "+#% to Chaos Resistance"
            @new_item.chaos_resistance += mod.total_value
            @new_item.total_resistance += mod.total_value
            @new_item.num_resistances += 1
          when "+#% to Fire and Cold Resistances"
            @new_item.fire_resistance += mod.total_value
            @new_item.cold_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value*2
            @new_item.total_resistance += mod.total_value*2
            @new_item.num_ele_resistances += 2
            @new_item.num_resistances += 2
          when "+#% to Fire and Lightning Resistances"
            @new_item.fire_resistance += mod.total_value
            @new_item.lightning_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value*2
            @new_item.total_resistance += mod.total_value*2
            @new_item.num_ele_resistances += 2
            @new_item.num_resistances += 2
          when "+#% to Cold and Lightning Resistances"
            @new_item.cold_resistance += mod.total_value
            @new_item.lightning_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value*2
            @new_item.total_resistance += mod.total_value*2
            @new_item.num_ele_resistances += 2
            @new_item.num_resistances += 2
          when "+#% to Fire Resistance"
            @new_item.fire_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value
            @new_item.total_resistance += mod.total_value
            @new_item.num_ele_resistances += 1
            @new_item.num_resistances += 1
          when "+#% to all Elemental Resistances"
            @new_item.fire_resistance += mod.total_value
            @new_item.cold_resistance += mod.total_value
            @new_item.lightning_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value*3
            @new_item.total_resistance += mod.total_value*3
            @new_item.num_ele_resistances += 1
            @new_item.num_resistances += 1
          when "+#% to Lightning Resistance"
            @new_item.lightning_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value
            @new_item.total_resistance += mod.total_value
            @new_item.num_ele_resistances += 1
            @new_item.num_resistances += 1
          when "+#% to Cold Resistance"
            @new_item.cold_resistance += mod.total_value
            @new_item.total_ele_resistance += mod.total_value
            @new_item.total_resistance += mod.total_value
            @new_item.num_ele_resistances += 1
            @new_item.num_resistances += 1
          end
        end
        
        @new_item.save if @new_item.changed?
        
        added_items << @new_item
		  	
		  	@new_item = nil
		  end
	  end
	  
	  # Check for any stale items in the shop
	  destroyed = 0
	  shop.items.find_each do |itm|
	    unless added_items.include?(itm)
	      itm.destroy
	      destroyed += 1
      end
    end
    
    LOGGER.info "#{added_items.length} items added. #{destroyed} stale items destroyed in shop #{shop.thread}"
	  
	  shop.last_indexed = Time.now.utc
	  shop.save
	  
	  shop = nil
	  added_items = nil
	  @new_item_mods = nil
	  new_items = nil
	  
	end
	
	private
	
	def self.record_mods(item)
	  @implicit_mods = Hash.new
		# Implicit Mods
		if item["implicitMods"] and !item["implicitMods"].empty? then
      self.mods(item, item["implicitMods"], false, false)
		end

		# Explicit Mods
		if item["explicitMods"] and !item["explicitMods"].empty? then
      self.mods(item, item["explicitMods"], true, false)
		end
		
		# Crafted Mods (quasi-explicit)
		if item["craftedMods"] and !item["craftedMods"].empty? then
      self.mods(item, item["craftedMods"], true, true)
		end
  end
	
	def self.mods(item, mods, explicit=true, crafted=false)
	  mods.each do |mod|
			values = mod.scan(/\d*\.?\d+/)
			mod.gsub!(/\d*\.?\d+/, '#')
			if explicit
			    explicit_mod = Mod.where('UPPER(name) = ? AND explicit = TRUE AND total = FALSE', mod.upcase).first
  		    explicit_mod = Mod.create(name: mod, explicit: true, total: false) if explicit_mod.nil?
  		    m_id = explicit_mod.id
  	    if Mod.exists?(name: mod, explicit: false, total: false) then # also an implicit mod, so create a total as well
  	      total_mod = Mod.find_or_create_by(name: mod, total: true, explicit: true)
  	      matched_implicit_mod = Mod.where(name: mod, explicit: false, total: false).first.id
  	      matched_implicit_item_mod = @implicit_mods[matched_implicit_mod]
  	      if !values.empty? or !matched_implicit_item_mod.nil?
  	        mt = ItemMod.new(item: @new_item, mod_id: total_mod.id, crafted: crafted)
  	        mt.primary_value = 0
  	        mt.secondary_value = 0
  	        mt.total_value = 0
    				mt.primary_value += values[0].to_i if values[0]
    				mt.primary_value += matched_implicit_item_mod[:primary_value] unless matched_implicit_item_mod.nil?
    				mt.secondary_value += values[1].to_i if values[1]
    				mt.secondary_value += matched_implicit_item_mod[:secondary_value] unless matched_implicit_item_mod.nil?
    				mt.total_value += mt.primary_value+mt.secondary_value
    				@new_item_mods << mt
    			end
        end
		  else
  		    implicit_mod = Mod.where('UPPER(name) = ? AND explicit = FALSE AND total = FALSE', mod.upcase).first
  		    implicit_mod = Mod.create(name: mod, explicit: false, total: false) if implicit_mod.nil?
  		    m_id = implicit_mod.id
		  end
		  m = ItemMod.new(item: @new_item, mod_id: m_id, crafted: crafted)
			unless values.empty? then
			  m.primary_value = 0
			  m.secondary_value = 0
			  m.total_value = 0
				m.primary_value += values[0].to_i if values[0]
				m.secondary_value += values[1].to_i if values[1]
				m.total_value += m.primary_value+m.secondary_value
				@implicit_mods[m_id] = {:primary_value => m.primary_value, :secondary_value => m.secondary_value} unless explicit
			end
			@new_item_mods << m
		end
  end
	
	def self.check_item_tag(item_index)
	 tag = @result.xpath('//*[@id="item-fragment-'+item_index.to_s+'"]/following-sibling::node()[1]').text.strip.sub(',','.')
	 buyout = tag.scan(/.*?(~b\/o)(\s+)(\d+(\.\d*)?|\.\d+)(\s+)((?:[a-zA-Z][a-zA-Z]+))/)
	 if buyout.nil? or buyout.blank?
	   tag = @result.xpath('//*[@id="item-fragment-'+item_index.to_s+'"]/following-sibling::node()[2]').text.strip
   end
   return false if tag.blank?
 	 buyout = tag.scan(/.*?(~b\/o)(\s+)(\d+(\.\d*)?|\.\d+)(\s+)((?:[a-zA-Z][a-zA-Z]+))/) if buyout.nil? or buyout.blank?
 	 unless buyout.nil? or buyout.empty? then
		  item_buyout = []
		  item_buyout[0] = buyout[0][2].strip.to_f
		  item_buyout[1] = self.buyout_currency(buyout[0][5].to_s.strip.downcase)
   else
     false
   end
   item_buyout
  end
	
	def self.check_spoiler_tag(item_index)
    tags = @result.xpath('//*[@id="item-fragment-'+item_index.to_s+'"]/ancestor::div[contains(concat(" ", @class, " "), "spoiler")]/div[@class="spoilerTitle"]/span/text()')
		if tags.count > 0
		  tags.reverse_each do |tag|
		    buyout = tag.text.strip.sub(',','.').scan(/.*?(~b\/o)(\s+)(\d+(\.\d*)?|\.\d+)(\s+)((?:[a-zA-Z][a-zA-Z]+))/)
		    unless buyout.nil? or buyout.empty? then
		      item_buyout = []
		      item_buyout[0] = buyout[0][2].strip.to_f
		      item_buyout[1] = self.buyout_currency(buyout[0][5].to_s.strip.downcase)
		      return item_buyout
        end
      end
    end
    false
  end
  
  def self.buyout_currency(curr)
    currency_item = Currency.where("alternate_names ILIKE '%#{curr}%'")
    return currency_item.first if currency_item.count == 1
    currency_item.each do |c|
      return c if c.alternate_names.scan(/\b#{curr}\b/).count > 0
    end
    LOGGER.info "Unknown Currency #{curr}"
    false
  end
end