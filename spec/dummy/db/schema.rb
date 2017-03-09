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

ActiveRecord::Schema.define(version: 20170309081720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "corzinus_addresses", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "city"
    t.string   "zip"
    t.string   "phone"
    t.integer  "address_type"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.integer  "country_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["addressable_type", "addressable_id"], name: "index_corzinus_addresses_on_addressable_type_and_addressable_id", using: :btree
    t.index ["country_id"], name: "index_corzinus_addresses_on_country_id", using: :btree
  end

  create_table "corzinus_countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corzinus_coupons", force: :cascade do |t|
    t.integer  "discount"
    t.string   "code"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_corzinus_coupons_on_code", using: :btree
    t.index ["order_id"], name: "index_corzinus_coupons_on_order_id", using: :btree
  end

  create_table "corzinus_credit_cards", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.string   "cvv"
    t.string   "month_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id"
    t.integer  "product_id"
  end

  create_table "corzinus_deliveries", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      precision: 10, scale: 2
    t.integer  "min_days"
    t.integer  "max_days"
    t.integer  "country_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["country_id"], name: "index_corzinus_deliveries_on_country_id", using: :btree
  end

  create_table "corzinus_order_items", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "order_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "productable_type"
    t.integer  "productable_id"
    t.index ["order_id"], name: "index_corzinus_order_items_on_order_id", using: :btree
    t.index ["productable_type", "productable_id"], name: "index_corzinus_productable", using: :btree
  end

  create_table "corzinus_orders", force: :cascade do |t|
    t.string   "state"
    t.decimal  "total_price",      precision: 10, scale: 2
    t.integer  "delivery_id"
    t.integer  "credit_card_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "person_id"
    t.boolean  "use_base_address"
    t.index ["credit_card_id"], name: "index_corzinus_orders_on_credit_card_id", using: :btree
    t.index ["delivery_id"], name: "index_corzinus_orders_on_delivery_id", using: :btree
  end

  create_table "typical_products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price",      precision: 10, scale: 2
    t.integer  "count"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "typical_users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

end
