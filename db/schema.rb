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

ActiveRecord::Schema.define(version: 2021_04_18_044748) do

  create_table "instance_entries", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.integer "start_level"
    t.integer "start_xp"
    t.datetime "queue_pop_time"
    t.datetime "finish_time"
    t.integer "finish_level"
    t.integer "finish_xp"
    t.integer "xp_bonus"
    t.integer "roulette_bonus"
    t.integer "new_player_bonus"
    t.integer "role_in_need_bonus"
    t.integer "other_bonus"
    t.integer "commends"
    t.string "notes"
    t.integer "instance_id"
    t.integer "job_id"
    t.boolean "queue_outlier"
    t.boolean "duration_outlier"
    t.boolean "xp_outlier"
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
  end

end
