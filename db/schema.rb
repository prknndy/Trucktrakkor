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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101116000354) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_trucks", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "truck_id"
  end

  create_table "cities", :force => true do |t|
    t.string "name"
    t.string "display_name"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.text     "aliases"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keyword"
    t.string   "reg_match"
  end

  create_table "streets", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", :force => true do |t|
    t.string   "city"
    t.string   "name"
    t.string   "twitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recent_tweet"
    t.string   "website"
  end

  create_table "tweets", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.integer  "truck_id"
    t.integer  "location_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
