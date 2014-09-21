# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140826134241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "base_types", force: true do |t|
    t.string  "name"
    t.integer "item_type_id"
    t.integer "required_str", default: 0
    t.integer "required_dex", default: 0
    t.integer "required_int", default: 0
  end

  add_index "base_types", ["item_type_id"], name: "index_base_types_on_item_type_id", using: :btree

  create_table "currencies", force: true do |t|
    t.string "name"
    t.string "alternate_names"
    t.text   "icon_url"
  end

  add_index "currencies", ["name"], name: "index_currencies_on_name", using: :btree

  create_table "currency_ratios", force: true do |t|
    t.integer  "league_id"
    t.integer  "currency_id"
    t.decimal  "chaos_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currency_ratios", ["currency_id"], name: "index_currency_ratios_on_currency_id", using: :btree
  add_index "currency_ratios", ["league_id"], name: "index_currency_ratios_on_league_id", using: :btree

  create_table "forums", force: true do |t|
    t.string  "url"
    t.integer "league_id"
  end

  create_table "item_mods", force: true do |t|
    t.integer "item_id"
    t.integer "mod_id"
    t.integer "primary_value",   default: 0
    t.integer "secondary_value", default: 0
    t.integer "total_value",     default: 0
    t.boolean "crafted",         default: false
  end

  add_index "item_mods", ["crafted"], name: "index_item_mods_on_crafted", using: :btree
  add_index "item_mods", ["item_id", "mod_id"], name: "index_item_mods_on_item_id_and_mod_id", using: :btree
  add_index "item_mods", ["item_id"], name: "index_item_mods_on_item_id", using: :btree
  add_index "item_mods", ["mod_id"], name: "index_item_mods_on_mod_id", using: :btree

  create_table "item_types", force: true do |t|
    t.string  "name"
    t.string  "family", default: "Other"
    t.integer "order"
  end

  add_index "item_types", ["family"], name: "index_item_types_on_family", using: :btree
  add_index "item_types", ["name"], name: "index_item_types_on_name", using: :btree

  create_table "items", force: true do |t|
    t.integer  "league_id"
    t.integer  "shop_id"
    t.integer  "seller_id"
    t.string   "name"
    t.string   "rarity"
    t.integer  "base_type_id"
    t.integer  "item_type_id"
    t.decimal  "buyout_amount",          precision: 8, scale: 2, default: 0.0
    t.integer  "buyout_currency_id"
    t.text     "icon_url"
    t.integer  "w"
    t.integer  "h"
    t.integer  "quality",                                        default: 0
    t.boolean  "identified"
    t.boolean  "corrupted",                                      default: false
    t.integer  "physical_dmg_min",                               default: 0
    t.integer  "physical_dmg_max",                               default: 0
    t.integer  "fire_dmg_min",                                   default: 0
    t.integer  "fire_dmg_max",                                   default: 0
    t.integer  "cold_dmg_min",                                   default: 0
    t.integer  "cold_dmg_max",                                   default: 0
    t.integer  "lightning_dmg_min",                              default: 0
    t.integer  "lightning_dmg_max",                              default: 0
    t.integer  "chaos_dmg_min",                                  default: 0
    t.integer  "chaos_dmg_max",                                  default: 0
    t.decimal  "fire_dps",               precision: 8, scale: 2, default: 0.0
    t.decimal  "cold_dps",               precision: 8, scale: 2, default: 0.0
    t.decimal  "lightning_dps",          precision: 8, scale: 2, default: 0.0
    t.decimal  "chaos_dps",              precision: 8, scale: 2, default: 0.0
    t.decimal  "pdps",                   precision: 8, scale: 2, default: 0.0
    t.decimal  "edps",                   precision: 8, scale: 2, default: 0.0
    t.decimal  "dps",                    precision: 8, scale: 2, default: 0.0
    t.integer  "block"
    t.decimal  "critical_strike_chance", precision: 4, scale: 2, default: 0.0
    t.decimal  "attacks_per_second",     precision: 4, scale: 2, default: 0.0
    t.integer  "armour",                                         default: 0
    t.integer  "evasion_rating",                                 default: 0
    t.integer  "energy_shield",                                  default: 0
    t.integer  "mana_multiplier",                                default: 0
    t.string   "mana_reserved",                                  default: "0"
    t.integer  "mana_cost",                                      default: 0
    t.string   "cooldown_time"
    t.string   "item_desc"
    t.text     "description_text"
    t.integer  "item_level",                                     default: 0
    t.integer  "item_quantity",                                  default: 0
    t.integer  "required_level",                                 default: 0
    t.integer  "required_str",                                   default: 0
    t.integer  "required_dex",                                   default: 0
    t.integer  "required_int",                                   default: 0
    t.string   "sockets"
    t.integer  "num_sockets",                                    default: 0
    t.integer  "s_sockets",                                      default: 0
    t.integer  "d_sockets",                                      default: 0
    t.integer  "i_sockets",                                      default: 0
    t.integer  "w_sockets",                                      default: 0
    t.integer  "links",                                          default: 0
    t.integer  "s_links",                                        default: 0
    t.integer  "d_links",                                        default: 0
    t.integer  "i_links",                                        default: 0
    t.integer  "w_links",                                        default: 0
    t.text     "flavour_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "normalized_buyout",                              default: 0.0
    t.boolean  "alternative_art",                                default: false
    t.integer  "fire_resistance",                                default: 0
    t.integer  "cold_resistance",                                default: 0
    t.integer  "lightning_resistance",                           default: 0
    t.integer  "chaos_resistance",                               default: 0
    t.integer  "total_ele_resistance",                           default: 0
    t.integer  "total_resistance",                               default: 0
    t.integer  "num_ele_resistances",                            default: 0
    t.integer  "num_resistances",                                default: 0
  end

  add_index "items", ["alternative_art"], name: "index_items_on_alternative_art", where: "(alternative_art = true)", using: :btree
  add_index "items", ["base_type_id"], name: "index_items_on_base_type_id", using: :btree
  add_index "items", ["buyout_currency_id"], name: "index_items_on_buyout_currency_id", using: :btree
  add_index "items", ["identified"], name: "index_items_on_identified", where: "(identified = false)", using: :btree
  add_index "items", ["item_type_id", "league_id"], name: "index_items_on_item_type_id_and_league_id", using: :btree
  add_index "items", ["item_type_id"], name: "index_items_on_item_type_id", using: :btree
  add_index "items", ["item_type_id"], name: "one_h_item_type", where: "(item_type_id = ANY (ARRAY[9, 11, 10, 7, 12, 8, 17]))", using: :btree
  add_index "items", ["item_type_id"], name: "two_h_item_type", where: "(item_type_id = ANY (ARRAY[14, 16, 15, 6, 13]))", using: :btree
  add_index "items", ["league_id", "id"], name: "index_items_on_league_id_and_id", order: {"id"=>:desc}, using: :btree
  add_index "items", ["league_id"], name: "index_items_on_league_id", using: :btree
  add_index "items", ["name"], name: "items_name_idx", using: :gist
  add_index "items", ["normalized_buyout"], name: "index_items_on_normalized_buyout", where: "(buyout_amount <> (0)::numeric)", using: :btree
  add_index "items", ["seller_id"], name: "index_items_on_seller_id", using: :btree
  add_index "items", ["shop_id"], name: "index_items_on_shop_id", using: :btree

  create_table "leagues", force: true do |t|
    t.string  "name"
    t.integer "region_id", default: 1
  end

  create_table "mods", force: true do |t|
    t.string  "name"
    t.boolean "explicit", default: true
    t.boolean "total",    default: false
    t.boolean "popular",  default: false
  end

  add_index "mods", ["explicit", "total"], name: "index_mods_on_explicit_and_total", using: :btree
  add_index "mods", ["explicit"], name: "index_mods_on_explicit", where: "(explicit = true)", using: :btree
  add_index "mods", ["total"], name: "index_mods_on_total", where: "(total = true)", using: :btree

  create_table "regions", force: true do |t|
    t.string "name"
  end

  create_table "resistance_mods", force: true do |t|
    t.string "name"
  end

  create_table "searches", force: true do |t|
    t.string   "slug"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["slug"], name: "index_searches_on_slug", unique: true, using: :btree

  create_table "sellers", force: true do |t|
    t.string   "uuid"
    t.string   "account_name"
    t.string   "ign",              default: "**Pending**"
    t.string   "challenge_icon"
    t.boolean  "online",           default: false
    t.datetime "online_until"
    t.string   "steam_name"
    t.string   "steam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_seen_online"
    t.integer  "account_id"
    t.integer  "region_id",        default: 1
  end

  add_index "sellers", ["account_name"], name: "index_sellers_on_account_name", using: :btree
  add_index "sellers", ["last_seen_online"], name: "index_sellers_on_last_seen_online", using: :btree
  add_index "sellers", ["online"], name: "index_sellers_on_online", using: :btree
  add_index "sellers", ["online_until"], name: "index_sellers_on_online_until", using: :btree
  add_index "sellers", ["steam_id"], name: "index_sellers_on_steam_id", using: :btree
  add_index "sellers", ["steam_name"], name: "index_sellers_on_steam_name", using: :btree
  add_index "sellers", ["uuid"], name: "index_sellers_on_uuid", unique: true, using: :btree

  create_table "shops", force: true do |t|
    t.string   "thread"
    t.integer  "seller_id"
    t.datetime "last_updated"
    t.datetime "last_indexed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["last_indexed"], name: "index_shops_on_last_indexed", using: :btree
  add_index "shops", ["last_updated"], name: "index_shops_on_last_updated", using: :btree
  add_index "shops", ["seller_id"], name: "index_shops_on_seller_id", using: :btree
  add_index "shops", ["thread"], name: "index_shops_on_thread", using: :btree

end
