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

ActiveRecord::Schema[7.2].define(version: 2025_07_17_095355) do
  create_table "disbursements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "merchant_id", null: false
    t.string "reference", null: false
    t.date "disbursement_date", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.decimal "total_fees", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id", "reference"], name: "index_disbursements_on_merchant_id_and_reference", unique: true
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.string "disbursement_frequency", null: false
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
  end

  create_table "monthly_fees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "merchant_id", null: false
    t.string "month", null: false
    t.decimal "total_fees", precision: 10, scale: 2, null: false
    t.decimal "charged_fee", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id", "month"], name: "index_monthly_fees_on_merchant_id_and_month", unique: true
    t.index ["merchant_id"], name: "index_monthly_fees_on_merchant_id"
  end

  create_table "orders", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "merchant_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "disbursement_id"
    t.decimal "commission_fee", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["disbursement_id"], name: "index_orders_on_disbursement_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "monthly_fees", "merchants"
  add_foreign_key "orders", "disbursements"
  add_foreign_key "orders", "merchants"
end
