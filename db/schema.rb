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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110727203233) do

  create_table "activities", :force => true do |t|
    t.date     "date",        :null => false
    t.float    "time",        :null => false
    t.text     "description", :null => false
    t.integer  "project_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["date"], :name => "index_activities_on_date"
  add_index "activities", ["id"], :name => "index_activities_on_id", :unique => true
  add_index "activities", ["project_id"], :name => "index_activities_on_project_id"

  create_table "billing_codes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.text     "first_name",  :limit => 255, :null => false
    t.string   "last_name"
    t.string   "title"
    t.string   "phone"
    t.string   "email"
    t.integer  "customer_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["customer_id"], :name => "index_contacts_on_customer_id"
  add_index "contacts", ["id"], :name => "index_contacts_on_id", :unique => true

  create_table "countries", :force => true do |t|
    t.string   "iso"
    t.string   "name",           :null => false
    t.string   "printable_name", :null => false
    t.string   "iso3"
    t.integer  "numcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["id"], :name => "index_countries_on_id", :unique => true
  add_index "countries", ["name"], :name => "index_countries_on_name"
  add_index "countries", ["printable_name"], :name => "index_countries_on_printable_name"

  create_table "customers", :force => true do |t|
    t.text     "name",        :limit => 255, :null => false
    t.string   "phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "postal_code"
    t.string   "province"
    t.string   "country"
    t.integer  "user_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.text     "note"
  end

  add_index "customers", ["id"], :name => "index_customers_on_id", :unique => true
  add_index "customers", ["user_id"], :name => "index_customers_on_user_id"

  create_table "invoices", :force => true do |t|
    t.date     "issued_date", :null => false
    t.date     "due_date",    :null => false
    t.string   "subject",     :null => false
    t.float    "balance",     :null => false
    t.string   "status",      :null => false
    t.text     "note"
    t.integer  "currency_id", :null => false
    t.integer  "customer_id"
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"
  add_index "invoices", ["id"], :name => "index_invoices_on_id", :unique => true
  add_index "invoices", ["user_id"], :name => "index_invoices_on_user_id"

  create_table "localizations", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "reference"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "localizations", ["country_id"], :name => "index_localizations_on_country_id"
  add_index "localizations", ["id"], :name => "index_localizations_on_id", :unique => true
  add_index "localizations", ["name"], :name => "index_localizations_on_name"

  create_table "profiles", :force => true do |t|
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "phone_number"
    t.string   "localization"
    t.float    "hours_per_day"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "default_rate"
    t.string   "manager"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billing_code_id"
    t.boolean  "internal",         :default => false
    t.boolean  "status",           :default => true
    t.string   "billing_estimate"
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "project_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "slug"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
