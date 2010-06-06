# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100606040543) do

  create_table "divisions", :force => true do |t|
    t.string   "division_name", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

  create_table "leagues", :force => true do |t|
    t.string   "league_name", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "given_name", :limit => 20
    t.string   "surname",    :limit => 40
    t.string   "position",   :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", :force => true do |t|
    t.integer  "year_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.float    "avg"
    t.integer  "hr"
    t.integer  "rbi"
    t.integer  "runs"
    t.integer  "sb"
    t.float    "ops"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "team_city",   :limit => 20
    t.string   "team_name",   :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "division_id"
  end

  create_table "years", :force => true do |t|
    t.string   "year",        :limit => 4
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end