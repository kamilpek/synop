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

ActiveRecord::Schema.define(version: 20180813152829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "level"
    t.string   "intro"
    t.text     "content"
    t.datetime "time_from"
    t.datetime "time_for"
    t.integer  "clients",                  array: true
    t.integer  "number"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_alerts_on_category_id", using: :btree
    t.index ["user_id"], name: "index_alerts_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "image"
  end

  create_table "cities", force: :cascade do |t|
    t.integer "province"
    t.integer "county"
    t.integer "commune"
    t.integer "genre"
    t.string  "name"
    t.string  "name_add"
    t.float   "longitude"
    t.float   "latitude"
  end

  create_table "clients", force: :cascade do |t|
    t.string  "name"
    t.string  "person"
    t.string  "website"
    t.string  "email"
    t.integer "status"
    t.string  "access_token"
  end

  create_table "forecasts", force: :cascade do |t|
    t.integer  "station_number"
    t.datetime "next"
    t.string   "temperatures",                array: true
    t.float    "wind_speeds",                 array: true
    t.float    "wind_directs",                array: true
    t.float    "preasures",                   array: true
    t.string   "situations",                  array: true
    t.float    "precipitations",              array: true
    t.datetime "times_from",                  array: true
    t.datetime "times_to",                    array: true
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "hour"
    t.date     "date"
  end

  create_table "gios_measurments", force: :cascade do |t|
    t.integer  "station"
    t.datetime "calc_date"
    t.integer  "st_index"
    t.integer  "co_index"
    t.integer  "pm10_index"
    t.integer  "c6h6_index"
    t.integer  "no2_index"
    t.integer  "pm25_index"
    t.integer  "o3_index"
    t.integer  "so2_index"
    t.float    "co_value"
    t.float    "pm10_value"
    t.float    "c6h6_value"
    t.float    "no2_value"
    t.float    "pm25_value"
    t.float    "o3_value"
    t.float    "so2_value"
    t.datetime "co_date"
    t.datetime "pm10_date"
    t.datetime "c6h6_date"
    t.datetime "no2_date"
    t.datetime "pm25_date"
    t.datetime "o3_date"
    t.datetime "so2_date"
  end

  create_table "gios_stations", force: :cascade do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "number"
    t.string   "city"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gw_measurs", force: :cascade do |t|
    t.integer  "gw_station_id"
    t.datetime "datetime"
    t.float    "rain"
    t.float    "water"
    t.float    "winddir"
    t.float    "windlevel"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["gw_station_id"], name: "index_gw_measurs_on_gw_station_id", using: :btree
  end

  create_table "gw_stations", force: :cascade do |t|
    t.integer  "no"
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "active"
    t.boolean  "rain"
    t.boolean  "water"
    t.boolean  "winddir"
    t.boolean  "windlevel"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "level_normal"
    t.float    "level_max"
    t.float    "level_rise"
  end

  create_table "measurements", force: :cascade do |t|
    t.date     "date"
    t.integer  "hour"
    t.float    "temperature"
    t.float    "wind_speed"
    t.integer  "wind_direct"
    t.float    "humidity"
    t.float    "preasure"
    t.float    "rainfall"
    t.float    "et"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "station_number"
  end

  create_table "metar_raports", force: :cascade do |t|
    t.integer  "station"
    t.integer  "day"
    t.integer  "hour"
    t.string   "metar"
    t.text     "message"
    t.datetime "created_at"
    t.string   "visibility"
    t.string   "cloud_cover"
    t.string   "wind_direct"
    t.string   "wind_speed"
    t.string   "temperature"
    t.string   "pressure"
    t.string   "situation"
  end

  create_table "metar_stations", force: :cascade do |t|
    t.string   "name"
    t.integer  "number"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "elevation"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "radars", force: :cascade do |t|
    t.string   "cappi"
    t.string   "cmaxdbz"
    t.string   "eht"
    t.string   "pac"
    t.string   "zhail"
    t.string   "hshear"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sri"
    t.string   "rtr"
  end

  create_table "stations", force: :cascade do |t|
    t.text     "name"
    t.integer  "number"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "alerts", "categories"
  add_foreign_key "alerts", "users"
  add_foreign_key "gw_measurs", "gw_stations"
end
