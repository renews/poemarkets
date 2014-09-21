require 'open-uri'
require 'nokogiri'

class VerifyJob
  
  @queue = :verify_queue
  
  def self.perform(id)
    @verified = false
    @request = true
   # begin
    begin
      itv = Item.find(id)
    rescue ActiveRecord::RecordNotFound
      return { :request => @request, :verified => @verified }
    end
    # Open the shop url
	begin
		site = open(itv.shop.thread)
	rescue OpenURI::HTTPError => e
		itv.shop.destroy if e.message.include?('404')
		return { :request => false, :verified => @verified }
	end
	@result = Nokogiri::HTML(site)
		
		# Select item data
	  script = @result.css('script').last
	  string = script.content.to_s.strip
	  
	  # Remove the JSON we are interested in
	  start_index = string.index('new R(')
    end_index = string.index(')).run()')
    if start_index and end_index
	    json = string.slice((start_index+6)..end_index-1)
	  else # Shop has no items
	    @verified = false
	    return { :request => @request, :verified => @verified }
  	end
	  
	  # Parse the JSON
	  items_json = JSON.parse(json)
	  
	  items_json.each do |item|
	    same = false
	    item = item[1]
	    if (itv.name == item["name"] or (item["name"].blank? and itv.name.include?(item["typeLine"]))) then
	      same = true
	    end
	    
	    next unless same

	    if same and item["typeLine"].include?(itv.base_type.name) and itv.identified == item["identified"] and itv.corrupted == item["corrupted"] and itv.rarity.to_i == item["frameType"].to_i then
	      same = true
      end
      #puts "basic stats verified" if same
      #puts "basic stats UNVERIFIED" unless same
      next unless same
      if same and item["properties"] and !item["properties"].empty?
      	properties = item["properties"]
	  		properties.each do |property|
	  		  break unless same
		  		case property["name"]
		  			when "Armour" then
		  				armour = property["values"][0][0]
		  				same = false unless itv.armour == armour.to_i
		  		  when "Evasion Rating" then
		  		  	eva = property["values"][0][0]
		  		  	same = false unless itv.evasion_rating == eva.to_i
		  		  when "Energy Shield" then
		  		  	eng = property["values"][0][0]
		  		  	same = false unless itv.energy_shield == eng.to_i
		  		  when "Chance to Block" then
		  		    cb = property["values"][0][0].sub('%', '')
		  		    same = false unless itv.block == cb.to_i
				  	when "Physical Damage" then
				  		phys_dmg = property["values"][0][0].split('-')
				  		same = false unless itv.physical_dmg_min == phys_dmg[0].to_i and itv.physical_dmg_max == phys_dmg[1].to_i
				  	when "Elemental Damage" then
				  		property["values"].each do |value|
				  			ele_dmg = value[0].split('-')
				  			case value[1]
				  				when 4 then #Fire damage
				  					same = false unless itv.fire_dmg_min == ele_dmg[0].to_i and itv.fire_dmg_max == ele_dmg[1].to_i
				  				when 5 then #Cold damage
				  					same = false unless itv.cold_dmg_min == ele_dmg[0].to_i and itv.cold_dmg_max == ele_dmg[1].to_i
				  				when 6 then #Lightning damage
				  					same = false unless itv.lightning_dmg_min == ele_dmg[0].to_i and itv.lightning_dmg_max == ele_dmg[1].to_i
				  			end
				  		end
				  	when "Chaos Damage" then
				  		chaos_dmg = property["values"][0][0].split('-')
				  		same = false unless itv.chaos_dmg_min == chaos_dmg[0].to_i and itv.chaos_dmg_max == chaos_dmg[1].to_i
				  	when "Critical Strike Chance" then
				  		crit = property["values"][0][0].sub('%', '')
				  		same = false unless itv.critical_strike_chance == crit.to_f
				  	when "Attacks per Second" then
				  		aps = property["values"][0][0].to_f
				  		same = false unless itv.attacks_per_second == aps.to_f
				  	when "Level" then
				  		lvl = property["values"][0][0]
				  		same = false unless itv.item_level == lvl.to_i
				  	when "Mana Cost" then
				  	  mc = property["values"][0][0]
				  	  same = false unless itv.mana_cost == mc.to_i
				  	when "Mana Multiplier" then
				  		mm = property["values"][0][0].sub('%', '')
				  		same = false unless itv.mana_multiplier == mm.to_i
				  	when "Mana Reserved" then
				  		mr = property["values"][0][0]
				  		same = false unless itv.mana_reserved == mr.to_i
				  	when "Cooldown Time" then
				  		cd = property["values"][0][0].sub(' sec', '')
				  		same = false unless itv.cooldown_time == cd
				  	when "Quality" then
				  		qu = property["values"][0][0].sub('+', '').sub('%', '')
				  		same= false unless itv.quality == qu.to_i
				  	when "Map Level" then
				  	  ml = property["values"][0][0]
				  	  same = false unless itv.item_level == ml.to_i
			  	  when "Item Quantity" then
			  	    iq = property["values"][0][0].sub('+', '').sub('%', '')
			  	    same = false unless itv.item_quantity == iq.to_i
				  	else
				  		if property["values"].empty? then
				  			same = false unless itv.item_desc == property["name"]
				  		end
			  	end
			  	#puts "verified " + property["name"] if same
			  	#puts "UNVERIFIED " + property["name"] unless same
	  		end  
      else
        #puts "no properties -- skipped"
      end
      if same and item["sockets"] and !item["sockets"].empty? then
  			socket_string = ''
  			socket_group = item["sockets"][0]["group"]
  			item["sockets"].each_with_index do |socket, index|
  			if socket_group == socket["group"] then # Socket group same, must be linked
  						socket_string += '-' if index != 0
  				else
  						socket_string += ' ' if index != 0
  				end
  				socket_string += socket["attr"]
  				socket_group = socket["group"]
  			end
  			same = false unless itv.sockets == socket_string
  			#puts "verified sockets " + socket_string if same
  			#puts "UNVERIFIED sockets " unless same
  		else
  		  #puts "no sockets -- skipped"
		  end
      same = self.check_mods(itv, item) if same
      if same and item["verified"]
          itv.updated_at = Time.now
          itv.save
          @verified = true 
          break
	    end
    end
    
    if @verified
      itv.updated_at = Time.now
      itv.save
    else
      itv.destroy
    end
    
    return { :request => @request, :verified => @verified }
    
  end
	
	def self.check_mods(itv, item)
	  implicit = false
	  explicit = false
	  implicit_count = itv.implicit_mods.count
	  explicit_count = itv.explicit_mods.count
	  #puts "itv implicit count is #{implicit_count}"
	  #puts "itv explicit count is #{explicit_count}"
	  
		# Implicit Mods
		if item["implicitMods"] and !item["implicitMods"].empty? then
		  #puts "item implicit count is #{item['implicitMods'].count}"
		  return false unless item["implicitMods"].count == implicit_count
      implicit = mods(itv, item["implicitMods"], false)
		else
		  implicit = true if implicit_count == 0
		  #puts 'no implicit mods -- skipped'
		end  

		# Explicit Mods
		if item["explicitMods"] and !item["explicitMods"].empty? then
		  #puts "item explicit count is #{item['explicitMods'].count}"
		  return false unless item["explicitMods"].count == explicit_count
      explicit =  mods(itv, item["explicitMods"], true)
		else
		  explicit = true if explicit_count == 0
		  #puts 'no explicit mods -- skipped'
	  end
	  
	  # Crafted Mods
		if item["craftedMods"] and !item["craftedMods"].empty? then
      crafted =  mods(itv, item["craftedMods"], true, true)
		else
		  crafted = true
	  end
	  
	  
		
		implicit && explicit && crafted
  end
	
	def self.mods(itv, mods, explicit=true, crafted=false)
	  same = true
	  mods.each do |mod|
			values = mod.scan(/\d*\.?\d+/)
			mod.gsub!(/\d*\.?\d+/, '#')
			if explicit
        m = Mod.where(name: mod, explicit: true, total: false).first
		  else
        m = Mod.where(name: mod, explicit: false, total: false).first
		  end
      same = false unless itv.mods.include?(m)
			unless values.empty? then
			  im = ItemMod.where(mod: m, crafted: crafted)
			end
			#puts "verified #{mod}" if same
			#puts "UNVERIFIED #{mod}" unless same
		end
		same
	end
end