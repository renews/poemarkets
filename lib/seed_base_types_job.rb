require 'open-uri'
require 'nokogiri'

class SeedBaseTypesJob
  def self.perform
    self.seed_armour
    self.seed_weapons
    self.seed_jewelry
  end
  
  private
  
  def self.seed_armour
    site = Nokogiri::HTML(open('http://www.pathofexile.com/item-data/armour'))
    self.seed_items(site, 'Armour', 2)
  end
  
  def self.seed_weapons
    site = Nokogiri::HTML(open('http://www.pathofexile.com/item-data/weapon'))
    self.seed_items(site, 'Weapons', 1)
  end
  
  def self.seed_jewelry
    site = Nokogiri::HTML(open('http://www.pathofexile.com/item-data/jewelry'))
    item_types = site.css('div.layoutBox1')
    item_types.each do |item_type|
      type = item_type.css('h1.layoutBoxTitle').text
      type = ItemType.find_or_create_by(name: type, family: 'Jewelry', order: 3)
      items = item_type.css('table.itemDataTable tr')
      items.each do |item|
        next if item.css('td.name').empty?
        col = item.css('td.name')
        name = col.text
        unless BaseType.exists?(name: name)
          BaseType.create(name: name, item_type: type)
        end
      end
    end
  end
  
  def self.seed_items(site, family, order)
    item_types = site.css('div.layoutBox1')
    item_types.each do |item_type|
      type = item_type.css('h1.layoutBoxTitle').text
      case type
      when "Thrusting One Hand Sword"
        type = "One Hand Sword"
      end
      type = ItemType.find_or_create_by(name: type, family: family, order: order)
      items = item_type.css('table.itemDataTable tr')
      items.each do |item|
        next if item.css('td.name').empty?
        cols = item.css('td')
        name = cols[1].text
        required_str = cols[6].text.to_i
        required_dex = cols[7].text.to_i
        required_int = cols[8].text.to_i
        unless BaseType.exists?(name: name)
          BaseType.create(name: name, item_type: type, required_str: required_str, required_dex: required_dex, required_int: required_int)
        end
      end
    end
  end
end