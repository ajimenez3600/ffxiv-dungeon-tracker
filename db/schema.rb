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

ActiveRecord::Schema.define(version: 2021_05_01_193724) do

  create_table "expansions", force: :cascade do |t|
    t.string "name"
    t.integer "api_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "instance_entries", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time", null: false
    t.integer "start_level", null: false
    t.integer "start_xp", null: false
    t.datetime "queue_pop_time", null: false
    t.datetime "finish_time", null: false
    t.integer "finish_level", null: false
    t.integer "finish_xp", null: false
    t.integer "xp_bonus", default: 100, null: false
    t.integer "roulette_bonus", default: 0, null: false
    t.integer "new_player_bonus", default: 0, null: false
    t.integer "role_in_need_bonus", default: 0, null: false
    t.integer "other_bonus", default: 0, null: false
    t.integer "commends", default: 0, null: false
    t.string "notes", default: "0", null: false
    t.integer "instance_id"
    t.integer "job_id"
    t.boolean "queue_outlier", default: false, null: false
    t.boolean "duration_outlier", default: false, null: false
    t.boolean "xp_outlier", default: false, null: false
    t.integer "roulette_id"
  end

  create_table "instances", force: :cascade do |t|
    t.string "name"
    t.string "instance_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "expansion"
    t.integer "api_id"
    t.integer "required_level"
    t.integer "required_item_level"
    t.integer "level_sync"
    t.integer "item_level_sync"
    t.integer "boss_1_exp"
    t.integer "boss_2_exp"
    t.integer "boss_3_exp"
    t.integer "boss_4_exp"
    t.integer "final_boss_exp"
    t.integer "instance_clear_exp"
    t.integer "new_player_bonus_a"
    t.integer "new_player_bonus_b"
    t.boolean "alliance_roulette"
    t.boolean "expert_roulette"
    t.boolean "guild_hest_roulette"
    t.boolean "level_50_60_70_roulette"
    t.boolean "level_80_roulette"
    t.boolean "leveling_roulette"
    t.boolean "msq_roulette"
    t.boolean "mentor_roulette"
    t.boolean "normal_raid_roulette"
    t.boolean "trial_roulette"
    t.integer "expansion_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "abbr"
    t.string "category"
    t.integer "role_id"
  end

  create_table "levels", force: :cascade do |t|
    t.integer "number"
    t.integer "exp_to_next"
    t.integer "item_level_sync"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "recommended_dungeon_id"
    t.integer "total_xp"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roulettes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "grant_xp", default: false, null: false
  end

end
