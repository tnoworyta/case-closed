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

ActiveRecord::Schema.define(version: 20190324103627) do

  create_table "cases", force: :cascade do |t|
    t.string "name"
    t.string "case_uid"
    t.string "officer_email"
    t.string "officer_name"
    t.string "description"
    t.string "department_code"
    t.boolean "important"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hero_cases", force: :cascade do |t|
    t.integer "hero_id"
    t.integer "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "heros", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string "student_email"
    t.string "tutor_email"
    t.datetime "datetime"
    t.integer "student_id"
    t.integer "tutor_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
  end

  create_table "tutors", force: :cascade do |t|
    t.string "email"
    t.string "calendar_type"
    t.string "calendar_id"
  end

end
