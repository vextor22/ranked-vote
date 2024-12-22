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

ActiveRecord::Schema[8.0].define(version: 2024_12_21_215906) do
  create_table "poll_choices", force: :cascade do |t|
    t.string "name"
    t.integer "poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_poll_choices_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voter_choices", force: :cascade do |t|
    t.integer "voter_id", null: false
    t.integer "poll_choice_id", null: false
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_choice_id"], name: "index_voter_choices_on_poll_choice_id"
    t.index ["voter_id"], name: "index_voter_choices_on_voter_id"
  end

  create_table "voters", force: :cascade do |t|
    t.string "name"
    t.integer "poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_voters_on_poll_id"
  end

  add_foreign_key "poll_choices", "polls"
  add_foreign_key "voter_choices", "poll_choices"
  add_foreign_key "voter_choices", "voters"
  add_foreign_key "voters", "polls"
end
