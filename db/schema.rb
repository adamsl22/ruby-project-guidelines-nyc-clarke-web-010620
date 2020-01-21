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

ActiveRecord::Schema.define(version: 4) do

  create_table "dragons", force: :cascade do |t|
    t.string  "name"
    t.string  "wing_span"
    t.string  "color"
    t.string  "pattern"
    t.integer "hunger"
    t.string  "health"
  end

  create_table "raid_pairings", force: :cascade do |t|
    t.integer "raid_id"
    t.integer "dragon_id"
  end

  create_table "raids", force: :cascade do |t|
    t.integer "village_id"
    t.integer "dice_roll"
  end

  create_table "villages", force: :cascade do |t|
    t.string  "name"
    t.integer "population"
    t.integer "knights"
    t.integer "slayers"
  end

end
