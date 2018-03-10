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

ActiveRecord::Schema.define(version: 20180307073130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
