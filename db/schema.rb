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

ActiveRecord::Schema.define(:version => 20121212205756) do

  create_table "case_studies", :force => true do |t|
    t.text     "approach"
    t.text     "challenges"
    t.text     "context"
    t.text     "html"
    t.text     "lessons"
    t.integer  "language_id"
    t.text     "recommendations"
    t.text     "results"
    t.text     "summary"
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "case_studies", ["title"], :name => "index_case_studies_on_title", :unique => true

  create_table "documents", :force => true do |t|
    t.string   "author"
    t.string   "file"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.string   "file_hash"
    t.text     "description"
    t.integer  "language_id"
    t.string   "title"
    t.string   "photo"
    t.boolean  "restricted",          :default => false
    t.string   "source"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "languages", ["code"], :name => "index_languages_on_code", :unique => true
  add_index "languages", ["name"], :name => "index_languages_on_name", :unique => true

  create_table "libraries", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.boolean  "official",    :default => false
    t.integer  "owner_id"
    t.string   "photo"
    t.boolean  "restricted",  :default => false
    t.boolean  "shared",      :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "links", :force => true do |t|
    t.text     "description"
    t.integer  "language_id"
    t.string   "name"
    t.text     "url"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "links", ["url"], :name => "index_links_on_url", :unique => true

  create_table "moments", :force => true do |t|
    t.string   "asset_caption"
    t.string   "asset_credit"
    t.text     "asset_media"
    t.string   "headline"
    t.date     "startdate"
    t.date     "enddate"
    t.text     "text"
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "language_id", :default => 1
    t.string   "title"
    t.text     "html",        :default => "<p>No content.</p>"
    t.integer  "locked_by"
    t.datetime "locked_at"
    t.integer  "user_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "photos", :force => true do |t|
    t.string   "attribution"
    t.text     "description"
    t.integer  "photo_height"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "photo"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "photo_hash"
    t.string   "title"
    t.integer  "user_id"
    t.integer  "photo_width"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "photos", ["photo_hash"], :name => "index_photos_on_photo_hash", :unique => true

  create_table "references", :force => true do |t|
    t.string   "link_text"
    t.integer  "link_target_id"
    t.string   "link_target_type"
    t.integer  "link_source_id"
    t.string   "link_source_type"
    t.integer  "target_count",     :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "photo"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "regions", ["abbreviation"], :name => "index_regions_on_abbreviation", :unique => true
  add_index "regions", ["name"], :name => "index_regions_on_name", :unique => true

  create_table "revisions", :force => true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.text     "html"
    t.integer  "page_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sectors", :force => true do |t|
    t.string   "abbreviation"
    t.integer  "apcd_id"
    t.string   "name"
    t.string   "photo"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "sectors", ["abbreviation"], :name => "index_sectors_on_abbreviation", :unique => true
  add_index "sectors", ["name"], :name => "index_sectors_on_name", :unique => true

  create_table "stacks", :force => true do |t|
    t.integer  "library_id"
    t.integer  "stackable_id"
    t.string   "stackable_type"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "staff", :force => true do |t|
    t.integer  "user_id"
    t.string   "location"
    t.text     "job_description_html"
    t.text     "job_description_markdown", :default => "No job description."
    t.string   "job_title"
    t.integer  "unit_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "staff", ["user_id"], :name => "index_staff_on_user_id", :unique => true

  create_table "stages", :force => true do |t|
    t.date     "anticipated_cos"
    t.date     "arrival"
    t.date     "swear_in"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "stages", ["anticipated_cos"], :name => "index_stages_on_anticipated_cos", :unique => true
  add_index "stages", ["arrival"], :name => "index_stages_on_arrival", :unique => true
  add_index "stages", ["swear_in"], :name => "index_stages_on_swear_in", :unique => true

  create_table "timelines", :force => true do |t|
    t.string   "asset_caption"
    t.string   "asset_credit"
    t.text     "asset_media"
    t.string   "headline"
    t.date     "startdate"
    t.text     "text"
    t.string   "ttype",         :default => "default"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "timelines", ["headline"], :name => "index_timelines_on_headline", :unique => true

  create_table "units", :force => true do |t|
    t.text     "description"
    t.integer  "head_id"
    t.string   "name"
    t.string   "photo"
    t.string   "photo_content_type"
    t.string   "photo_file_size"
    t.string   "photo_hash"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",                      :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "verified_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar"
    t.string   "avatar_content_type"
    t.string   "avatar_file_size"
    t.text     "bio"
    t.text     "bio_markdown",                         :default => "This user has no bio."
    t.string   "blog_title"
    t.string   "blog_url"
    t.string   "phone"
    t.string   "website"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "valid_emails", :force => true do |t|
    t.string   "email"
    t.datetime "checked_in_at"
    t.datetime "expires_at"
    t.string   "permissions",   :default => "volunteer"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "volunteers", :force => true do |t|
    t.integer  "user_id"
    t.text     "service_info_html"
    t.text     "service_info_markdown", :default => "No service info provided."
    t.integer  "stage_id"
    t.string   "local_name"
    t.string   "site"
    t.integer  "sector_id"
    t.date     "cos_date"
    t.integer  "work_zone_id"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "volunteers", ["user_id"], :name => "index_volunteers_on_user_id", :unique => true

  create_table "work_zones", :force => true do |t|
    t.string   "abbreviation"
    t.integer  "leader_id"
    t.string   "name"
    t.string   "photo"
    t.integer  "region_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "work_zones", ["abbreviation"], :name => "index_work_zones_on_abbreviation", :unique => true
  add_index "work_zones", ["name", "region_id"], :name => "index_work_zones_on_name_and_region_id", :unique => true

end
