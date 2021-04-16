# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_15_234918) do

  create_table "instance_entries", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.string "roulette_name"
    t.string "job_name"
    t.decimal "start_level"
    t.decimal "start_xp"
    t.datetime "queue_pop_time"
    t.string "instance_selection"
    t.datetime "finish_time"
    t.decimal "finish_level"
    t.decimal "finish_xp"
    t.decimal "xp_bonus"
    t.decimal "roulette_bonus"
    t.decimal "new_player_bonus"
    t.decimal "role_in_need_bonus"
    t.decimal "other_bonus"
    t.decimal "commends"
    t.boolean "queue_outlier?"
    t.boolean "duration_outlier?"
    t.boolean "xp_outlier?"
    t.string "notes"
  end

  create_table "instances", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "min_level"
    t.integer "max_level"
    t.integer "min_ilvl"
    t.integer "max_ilvl"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
