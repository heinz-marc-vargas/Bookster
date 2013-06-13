# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130506010612) do

  create_table "branches", :force => true do |t|
    t.string   "branch_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "name"
    t.integer  "zipcode"
    t.integer  "status"
    t.integer  "country_id"
    t.string   "address_1"
    t.string   "address_2"
    t.integer  "deleted",           :default => 0
    t.string   "subdomain"
    t.boolean  "notify_enabled",    :default => true
    t.text     "notify_options"
    t.string   "contact_firstname"
    t.string   "contact_lastname"
    t.string   "email"
    t.string   "contact_number"
    t.string   "city"
    t.string   "state"
    t.datetime "reminded_at"
  end

  add_index "branches", ["subdomain"], :name => "index_branches_on_subdomain", :unique => true

  create_table "closed_dates", :force => true do |t|
    t.integer  "total_days"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.string   "blockable_type"
    t.integer  "blockable_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "homepage"
    t.text     "description"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                          :default => 0
    t.integer  "deleted",                         :default => 0
    t.string   "subdomain"
    t.string   "plan"
    t.datetime "plan_start_at"
    t.datetime "plan_end_at"
    t.string   "business_type"
    t.string   "contact_firstname"
    t.string   "contact_lastname"
    t.string   "contact_number",    :limit => 20
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "country_id"
    t.string   "lat",               :limit => 50
    t.string   "lng",               :limit => 50
    t.string   "progress_status",   :limit => 50
  end

  add_index "companies", ["subdomain"], :name => "index_companies_on_subdomain", :unique => true

  create_table "companies_users", :id => false, :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "company_id", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name",       :limit => 50, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
    t.string   "language"
  end

  create_table "customers", :force => true do |t|
    t.string   "phone_number",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_1"
    t.string   "address_2"
    t.integer  "zipcode"
    t.integer  "country_id"
    t.integer  "company_id"
    t.integer  "deleted",      :default => 0
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
    t.integer  "staff_id"
    t.integer  "customer_id"
    t.integer  "branch_id"
    t.integer  "status",                :default => 0
    t.datetime "reminder_delivered_at"
    t.integer  "day_reminder"
    t.string   "memo"
    t.string   "customer_type"
  end

  create_table "notes", :force => true do |t|
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.text     "contents"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_days", :force => true do |t|
    t.integer  "day_of_week"
    t.integer  "operating_hour_id"
    t.integer  "branch_id"
    t.integer  "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_id"
    t.string   "resource_type"
  end

  create_table "operating_hours", :force => true do |t|
    t.integer  "am_start_time"
    t.integer  "am_end_time"
    t.integer  "pm_start_time"
    t.integer  "pm_end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_day_id"
  end

  create_table "review_links", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "event_id"
    t.string   "link"
    t.string   "token"
    t.boolean  "used"
    t.date     "expire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "branch_id",                                     :null => false
    t.integer  "customer_id",                                   :null => false
    t.integer  "rating",                                        :null => false
    t.string   "comment",     :limit => 500,                    :null => false
    t.boolean  "approved",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "staff_id"
  end

  create_table "service_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "duration"
    t.integer  "charge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calendar_css"
    t.integer  "status",              :default => 0
    t.integer  "deleted",             :default => 0
    t.integer  "branch_id"
    t.integer  "service_category_id"
    t.integer  "sequence_no",         :default => 0
  end

  create_table "services_staffs", :force => true do |t|
    t.integer "service_id"
    t.integer "staff_id"
  end

  create_table "settings", :force => true do |t|
    t.integer  "company_id"
    t.integer  "branch_id"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staff", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "years_exp"
    t.text     "description"
    t.date     "date_started"
    t.string   "specialization"
    t.string   "comments"
    t.integer  "branch_id"
    t.string   "photo"
    t.integer  "status",         :default => 0
    t.integer  "deleted",        :default => 0
    t.string   "alias"
    t.boolean  "display_email"
    t.boolean  "display_phone"
    t.string   "tel"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               :limit => 30
    t.string   "first_name",             :limit => 30
    t.string   "last_name",              :limit => 30
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.integer  "status",                               :default => 0
    t.string   "avatar"
    t.integer  "country_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["resource_type", "resource_id"], :name => "index_users_on_resource_type_and_resource_id"

end
