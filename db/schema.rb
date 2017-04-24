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

ActiveRecord::Schema.define(version: 20170424083722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_expense_attachments", force: :cascade do |t|
    t.integer  "client_expense_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "expense_file_file_name"
    t.string   "expense_file_content_type"
    t.integer  "expense_file_file_size"
    t.datetime "expense_file_updated_at"
    t.index ["client_expense_id"], name: "index_client_expense_attachments_on_client_expense_id", using: :btree
  end

  create_table "client_expenses", force: :cascade do |t|
    t.string   "expense_name"
    t.decimal  "amount",              precision: 8, scale: 2
    t.string   "vendor_name"
    t.date     "expense_date"
    t.text     "description"
    t.decimal  "start_mileage",       precision: 8, scale: 2
    t.decimal  "end_mileage",         precision: 8, scale: 2
    t.integer  "client_id"
    t.integer  "expense_category_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "created_by_id"
    t.integer  "status",                                      default: 0
    t.index ["client_id"], name: "index_client_expenses_on_client_id", using: :btree
    t.index ["created_by_id"], name: "index_client_expenses_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_client_expenses_on_deleted_at", using: :btree
    t.index ["expense_category_id"], name: "index_client_expenses_on_expense_category_id", using: :btree
  end

  create_table "client_services", force: :cascade do |t|
    t.string   "service_name"
    t.integer  "user_id"
    t.integer  "client_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.index ["client_type_id"], name: "index_client_services_on_client_type_id", using: :btree
    t.index ["deleted_at"], name: "index_client_services_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_client_services_on_user_id", using: :btree
  end

  create_table "client_tasks", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "task_name"
    t.text     "task_description"
    t.integer  "assign_to_id"
    t.datetime "due_date"
    t.integer  "for_customer_id"
    t.integer  "status",                  default: 0
    t.integer  "mark_as_completed_by_id"
    t.integer  "created_by_id"
    t.datetime "completed_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["assign_to_id"], name: "index_client_tasks_on_assign_to_id", using: :btree
    t.index ["client_id"], name: "index_client_tasks_on_client_id", using: :btree
    t.index ["created_by_id"], name: "index_client_tasks_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_client_tasks_on_deleted_at", using: :btree
    t.index ["for_customer_id"], name: "index_client_tasks_on_for_customer_id", using: :btree
    t.index ["mark_as_completed_by_id"], name: "index_client_tasks_on_mark_as_completed_by_id", using: :btree
  end

  create_table "client_types", force: :cascade do |t|
    t.string   "client_type_name"
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_client_types_on_deleted_at", using: :btree
  end

  create_table "clients_customers", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_clients_customers_on_deleted_at", using: :btree
  end

  create_table "clients_workers", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "worker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_clients_workers_on_deleted_at", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "billing_period"
    t.boolean  "should_print_invoice",  default: false, null: false
    t.boolean  "has_email_invoice",     default: false, null: false
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "deleted_at"
    t.text     "billing_notifications", default: [],                 array: true
    t.text     "service_notifications", default: [],                 array: true
    t.index ["deleted_at"], name: "index_customers_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_customers_on_user_id", using: :btree
  end

  create_table "customers_service_prices", force: :cascade do |t|
    t.decimal  "price",             precision: 8, scale: 2
    t.integer  "client_service_id"
    t.integer  "customer_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "deleted_at"
    t.index ["client_service_id"], name: "index_customers_service_prices_on_client_service_id", using: :btree
    t.index ["deleted_at"], name: "index_customers_service_prices_on_deleted_at", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string   "expense_category_name"
    t.integer  "client_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
    t.index ["client_id"], name: "index_expense_categories_on_client_id", using: :btree
    t.index ["deleted_at"], name: "index_expense_categories_on_deleted_at", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "invoice_number"
    t.integer  "status",            default: 0
    t.datetime "sent_on"
    t.integer  "service_ticket_id"
    t.integer  "sent_by_id"
    t.integer  "customer_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
    t.index ["deleted_at"], name: "index_invoices_on_deleted_at", using: :btree
    t.index ["sent_by_id"], name: "index_invoices_on_sent_by_id", using: :btree
    t.index ["service_ticket_id"], name: "index_invoices_on_service_ticket_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_oauth_access_grants_on_deleted_at", using: :btree
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_oauth_applications_on_deleted_at", using: :btree
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree
  end

  create_table "roles_users", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_users_on_deleted_at", using: :btree
    t.index ["role_id"], name: "index_roles_users_on_role_id", using: :btree
    t.index ["user_id"], name: "index_roles_users_on_user_id", using: :btree
  end

  create_table "service_ticket_attachments", force: :cascade do |t|
    t.integer  "service_ticket_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.index ["service_ticket_id"], name: "index_service_ticket_attachments_on_service_ticket_id", using: :btree
  end

  create_table "service_ticket_items", force: :cascade do |t|
    t.text     "description"
    t.decimal  "qty_hrs",           precision: 8, scale: 2
    t.decimal  "rate",              precision: 8, scale: 2
    t.decimal  "tax_rate",          precision: 8, scale: 2
    t.decimal  "cost",              precision: 8, scale: 2
    t.integer  "service_ticket_id"
    t.integer  "client_service_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["client_service_id"], name: "index_service_ticket_items_on_client_service_id", using: :btree
    t.index ["deleted_at"], name: "index_service_ticket_items_on_deleted_at", using: :btree
    t.index ["service_ticket_id"], name: "index_service_ticket_items_on_service_ticket_id", using: :btree
  end

  create_table "service_tickets", force: :cascade do |t|
    t.datetime "service_creation_date"
    t.text     "note"
    t.boolean  "has_next_visit",        default: false, null: false
    t.integer  "status",                default: 0
    t.integer  "customer_id"
    t.integer  "created_by_id"
    t.integer  "client_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "due_date"
    t.index ["client_id"], name: "index_service_tickets_on_client_id", using: :btree
    t.index ["created_by_id"], name: "index_service_tickets_on_created_by_id", using: :btree
    t.index ["customer_id"], name: "index_service_tickets_on_customer_id", using: :btree
    t.index ["deleted_at"], name: "index_service_tickets_on_deleted_at", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "service_name"
    t.integer  "client_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.index ["client_type_id"], name: "index_services_on_client_type_id", using: :btree
    t.index ["deleted_at"], name: "index_services_on_deleted_at", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "active",                 default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "subdomain"
    t.string   "phone"
    t.string   "unconfirmed_email"
    t.string   "nick_name"
    t.text     "address"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.integer  "zip"
    t.string   "alternate_phone"
    t.string   "alternate_email"
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NOT NULL)", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "users_client_types", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.index ["client_type_id"], name: "index_users_client_types_on_client_type_id", using: :btree
    t.index ["deleted_at"], name: "index_users_client_types_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_users_client_types_on_user_id", using: :btree
  end

  add_foreign_key "client_expenses", "users", column: "created_by_id"
  add_foreign_key "client_services", "client_types"
  add_foreign_key "client_services", "users"
  add_foreign_key "client_tasks", "users", column: "assign_to_id"
  add_foreign_key "client_tasks", "users", column: "client_id"
  add_foreign_key "client_tasks", "users", column: "created_by_id"
  add_foreign_key "client_tasks", "users", column: "for_customer_id"
  add_foreign_key "client_tasks", "users", column: "mark_as_completed_by_id"
  add_foreign_key "customers", "users"
  add_foreign_key "customers_service_prices", "client_services"
  add_foreign_key "invoices", "service_tickets"
  add_foreign_key "invoices", "users", column: "customer_id"
  add_foreign_key "invoices", "users", column: "sent_by_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "service_ticket_attachments", "service_tickets"
  add_foreign_key "service_ticket_items", "client_services"
  add_foreign_key "service_ticket_items", "service_tickets"
  add_foreign_key "service_tickets", "users", column: "client_id"
  add_foreign_key "service_tickets", "users", column: "created_by_id"
  add_foreign_key "service_tickets", "users", column: "customer_id"
  add_foreign_key "services", "client_types"
  add_foreign_key "users_client_types", "client_types"
  add_foreign_key "users_client_types", "users"
end
