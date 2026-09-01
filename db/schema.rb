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

ActiveRecord::Schema[8.1].define(version: 2026_09_01_180800) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "features", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "max_unit_limit"
    t.string "name", null: false
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_features_on_code", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "expires_at"
    t.integer "inviter_id", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "payment_authorizations", force: :cascade do |t|
    t.boolean "authorized"
    t.datetime "created_at", null: false
    t.string "stripe_customer_id"
    t.string "stripe_payment_method_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_payment_authorizations_on_user_id"
  end

  create_table "plan_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "feature_id", null: false
    t.decimal "max_unit_price"
    t.integer "plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_plan_features_on_feature_id"
    t.index ["plan_id", "feature_id"], name: "index_plan_features_on_plan_and_feature", unique: true
    t.index ["plan_id"], name: "index_plan_features_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "monthly_fee"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["role"], name: "index_roles_on_role", unique: true
  end

  create_table "subscription_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_using", default: false, null: false
    t.string "status", null: false
    t.integer "subscription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_subscription_statuses_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "plan_id", null: false
    t.datetime "started_at"
    t.datetime "unsubscribed_at"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "occurred_at"
    t.string "status"
    t.string "stripe_payment_id"
    t.integer "subscription_id", null: false
    t.string "transaction_type"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["subscription_id"], name: "index_transactions_on_subscription_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "usage_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "plan_feature_id", null: false
    t.integer "quantity"
    t.integer "subscription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_feature_id"], name: "index_usage_entries_on_plan_feature_id"
    t.index ["subscription_id"], name: "index_usage_entries_on_subscription_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "billing_day"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invitations", "users", column: "inviter_id"
  add_foreign_key "payment_authorizations", "users"
  add_foreign_key "plan_features", "features"
  add_foreign_key "plan_features", "plans"
  add_foreign_key "subscription_statuses", "subscriptions"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "transactions", "subscriptions"
  add_foreign_key "transactions", "users"
  add_foreign_key "usage_entries", "plan_features"
  add_foreign_key "usage_entries", "subscriptions"
  add_foreign_key "users", "roles"
end
