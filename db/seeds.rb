# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'seed_base_types_job'
require 'csv'
SeedBaseTypesJob.perform
CSV.foreach("#{Rails.root}/lib/data/additional-base-types.csv") do |row|
  item_type = ItemType.find_or_create_by(name: row[0])
  BaseType.find_or_create_by(name: row[1], item_type: item_type)
end
CSV.foreach("#{Rails.root}/lib/data/mods.csv") do |row|
  Mod.find_or_create_by(name: row[0], explicit: row[1], total: row[2])
end
gem_type = ItemType.find_or_create_by(name: 'Gem')
CSV.foreach("#{Rails.root}/lib/data/gems.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: gem_type)
end
vaal_gem_type = ItemType.find_or_create_by(name: 'Vaal Gem')
CSV.foreach("#{Rails.root}/lib/data/vaal-gems.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: vaal_gem_type)
end
vaal_fragment_type = ItemType.find_or_create_by(name: 'Vaal Fragment')
CSV.foreach("#{Rails.root}/lib/data/vaal-fragments.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: vaal_fragment_type)
end
map_type = ItemType.find_or_create_by(name: 'Map')
CSV.foreach("#{Rails.root}/lib/data/maps.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: map_type)
end
quiver_type = ItemType.find_or_create_by(name: 'Quiver')
CSV.foreach("#{Rails.root}/lib/data/quivers.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: quiver_type)
end
flask_type = ItemType.find_or_create_by(name: 'Flask')
CSV.foreach("#{Rails.root}/lib/data/flasks.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: flask_type)
end
currency_type = ItemType.find_or_create_by(name: 'Currency')
CSV.foreach("#{Rails.root}/lib/data/currency.csv") do |row|
  BaseType.find_or_create_by(name: row[0], item_type: currency_type)
end
CSV.foreach("#{Rails.root}/lib/data/buyout-currency.csv") do |row|
  Currency.find_or_create_by(name: row[0], alternate_names: row[1], icon_url: row[2])
end
CSV.foreach("#{Rails.root}/lib/data/resistance-mods.csv") do |row|
  ResistanceMod.find_or_create_by(name: row[0])
end
CSV.foreach("#{Rails.root}/lib/data/popular-mods.csv") do |row|
  mods = Mod.where(name: row[0].strip, explicit: true)
  mods.each do |mod|
    mod.popular = true
    mod.save
  end
end
region = Region.find_or_create_by(name: 'Global')
league_standard = League.find_or_create_by(name: 'Standard', region: region)
league_hardcore = League.find_or_create_by(name: 'Hardcore', region: region)

# Garena
region = Region.find_or_create_by(name: 'Garena')
league_standard = League.find_or_create_by(name: 'Garena-Standard', region: region)
league_hardcore = League.find_or_create_by(name: 'Garena-Hardcore', region: region)

