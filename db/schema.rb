# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_30_125937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachfiles", force: :cascade do |t|
    t.text "document_data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.text "topic"
    t.boolean "public", default: true
    t.text "description"
    t.bigint "workspace_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["workspace_id"], name: "index_channels_on_workspace_id"
  end

  create_table "directmsgs", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id"], name: "index_directmsgs_on_workspace_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "receiver_email"
    t.string "invitation_token"
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.datetime "accept_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accept_at"], name: "index_invitations_on_accept_at"
    t.index ["user_id"], name: "index_invitations_on_user_id"
    t.index ["workspace_id"], name: "index_invitations_on_workspace_id"
  end

  create_table "message_files", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "attachfile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachfile_id"], name: "index_message_files_on_attachfile_id"
    t.index ["message_id"], name: "index_message_files_on_message_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "messageable_type", null: false
    t.bigint "messageable_id", null: false
    t.integer "share_message_id"
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_uid"
    t.string "google_token"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_channels", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_enter_at"
    t.index ["channel_id"], name: "index_users_channels_on_channel_id"
    t.index ["user_id"], name: "index_users_channels_on_user_id"
  end

  create_table "users_directmsgs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "directmsg_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_enter_at"
    t.index ["directmsg_id"], name: "index_users_directmsgs_on_directmsg_id"
    t.index ["user_id"], name: "index_users_directmsgs_on_user_id"
  end

  create_table "users_workspaces", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.index ["user_id"], name: "index_users_workspaces_on_user_id"
    t.index ["workspace_id"], name: "index_users_workspaces_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "channels", "workspaces"
  add_foreign_key "invitations", "users"
  add_foreign_key "invitations", "workspaces"
  add_foreign_key "message_files", "attachfiles"
  add_foreign_key "message_files", "messages"
  add_foreign_key "messages", "users"
  add_foreign_key "users_channels", "channels"
  add_foreign_key "users_channels", "users"
  add_foreign_key "users_directmsgs", "directmsgs"
  add_foreign_key "users_directmsgs", "users"
  add_foreign_key "users_workspaces", "users"
  add_foreign_key "users_workspaces", "workspaces"
end
