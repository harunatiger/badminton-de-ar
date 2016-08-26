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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160825102221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "announcements", force: :cascade do |t|
    t.string   "title",            default: ""
    t.string   "page_url",         default: "", null: false
    t.date     "posting_start_at",              null: false
    t.date     "posting_end_at",                null: false
    t.string   "banner_image_pc",  default: ""
    t.string   "banner_image_sp",  default: ""
    t.string   "banner_space",                               array: true
    t.date     "publish_date"
    t.text     "overview",         default: ""
    t.string   "external_url",     default: ""
    t.text     "detail_html",      default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "announcements", ["posting_end_at"], name: "index_announcements_on_posting_end_at", using: :btree
  add_index "announcements", ["posting_start_at"], name: "index_announcements_on_posting_start_at", using: :btree
  add_index "announcements", ["title"], name: "index_announcements_on_title", using: :btree

  create_table "auths", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "auths", ["user_id"], name: "index_auths_on_user_id", using: :btree

  create_table "browsing_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.datetime "viewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "browsing_histories", ["listing_id"], name: "index_browsing_histories_on_listing_id", using: :btree
  add_index "browsing_histories", ["user_id"], name: "index_browsing_histories_on_user_id", using: :btree
  add_index "browsing_histories", ["viewed_at"], name: "index_browsing_histories_on_viewed_at", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "code",       null: false
    t.integer  "discount"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "campaigns", ["code"], name: "index_campaigns_on_code", using: :btree
  add_index "campaigns", ["discount"], name: "index_campaigns_on_discount", using: :btree
  add_index "campaigns", ["type"], name: "index_campaigns_on_type", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "confections", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "name",                    null: false
    t.string   "url",        default: ""
    t.string   "image",      default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "confections", ["listing_id", "name"], name: "index_confections_on_listing_id_and_name", unique: true, using: :btree
  add_index "confections", ["listing_id"], name: "index_confections_on_listing_id", using: :btree

  create_table "dress_codes", force: :cascade do |t|
    t.integer  "listing_id"
    t.boolean  "wafuku",     default: false
    t.text     "note",       default: ""
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "dress_codes", ["listing_id"], name: "index_dress_codes_on_listing_id", using: :btree

  create_table "emergencies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "name",         null: false
    t.string   "phone"
    t.string   "email"
    t.string   "relationship", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "emergencies", ["profile_id"], name: "index_emergencies_on_profile_id", using: :btree
  add_index "emergencies", ["user_id"], name: "index_emergencies_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "from_user_id",      null: false
    t.integer  "to_user_id"
    t.integer  "listing_id"
    t.datetime "read_at"
    t.string   "type",              null: false
    t.datetime "soft_destroyed_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "favorites", ["from_user_id"], name: "index_favorites_on_from_user_id", using: :btree
  add_index "favorites", ["listing_id"], name: "index_favorites_on_listing_id", using: :btree
  add_index "favorites", ["soft_destroyed_at"], name: "index_favorites_on_soft_destroyed_at", using: :btree
  add_index "favorites", ["to_user_id"], name: "index_favorites_on_to_user_id", using: :btree
  add_index "favorites", ["type"], name: "index_favorites_on_type", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "friendable_id"
    t.string   "friendable_type"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blocker_id"
  end

  create_table "ga_campaign_tags", force: :cascade do |t|
    t.string   "default_url", default: ""
    t.string   "long_url",    default: ""
    t.string   "short_url",   default: ""
    t.string   "source",      default: ""
    t.string   "medium",      default: ""
    t.string   "term",        default: ""
    t.string   "content",     default: ""
    t.string   "name",        default: ""
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "ga_campaign_tags", ["long_url"], name: "index_ga_campaign_tags_on_long_url", using: :btree
  add_index "ga_campaign_tags", ["short_url"], name: "index_ga_campaign_tags_on_short_url", using: :btree

  create_table "help_categories", force: :cascade do |t|
    t.string   "name_ja"
    t.string   "name_en"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "help_categories", ["lft"], name: "index_help_categories_on_lft", using: :btree
  add_index "help_categories", ["parent_id"], name: "index_help_categories_on_parent_id", using: :btree
  add_index "help_categories", ["rgt"], name: "index_help_categories_on_rgt", using: :btree

  create_table "help_topics", force: :cascade do |t|
    t.integer  "help_category_id"
    t.string   "title_ja"
    t.string   "title_en"
    t.text     "body_ja"
    t.text     "body_en"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "order_num",        default: 0
    t.string   "image",            default: ""
    t.string   "video_id",         default: ""
  end

  add_index "help_topics", ["help_category_id"], name: "index_help_topics_on_help_category_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listing_categories", force: :cascade do |t|
    t.integer  "listing_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "listing_categories", ["category_id"], name: "index_listing_categories_on_category_id", using: :btree
  add_index "listing_categories", ["listing_id"], name: "index_listing_categories_on_listing_id", using: :btree

  create_table "listing_details", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "zipcode"
    t.string   "location",                                      default: ""
    t.string   "place",                                         default: ""
    t.decimal  "longitude",             precision: 9, scale: 6, default: 0.0
    t.decimal  "latitude",              precision: 9, scale: 6, default: 0.0
    t.integer  "price",                                         default: 0
    t.decimal  "time_required",         precision: 9, scale: 6, default: 0.0
    t.integer  "max_num_of_people",                             default: 0
    t.integer  "min_num_of_people",                             default: 0
    t.text     "condition",                                     default: ""
    t.text     "refund_policy",                                 default: ""
    t.text     "in_case_of_rain",                               default: ""
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.text     "place_memo",                                    default: ""
    t.decimal  "place_longitude",       precision: 9, scale: 6, default: 0.0
    t.decimal  "place_latitude",        precision: 9, scale: 6, default: 0.0
    t.integer  "price_for_support",                             default: 0
    t.integer  "price_for_both_guides",                         default: 0
    t.boolean  "space_option",                                  default: true
    t.integer  "space_rental",                                  default: 0
    t.boolean  "car_option",                                    default: true
    t.integer  "car_rental",                                    default: 0
    t.integer  "gas",                                           default: 0
    t.integer  "highway",                                       default: 0
    t.integer  "parking",                                       default: 0
    t.integer  "guests_cost",                                   default: 0
    t.text     "included_guests_cost",                          default: ""
    t.boolean  "stop_if_rain",                                  default: false
    t.boolean  "bicycle_option",                                default: false
    t.integer  "bicycle_rental",                                default: 0
    t.boolean  "other_option",                                  default: false
    t.integer  "other_cost",                                    default: 0
    t.boolean  "register_detail",                               default: false
  end

  add_index "listing_details", ["latitude"], name: "index_listing_details_on_latitude", using: :btree
  add_index "listing_details", ["listing_id"], name: "index_listing_details_on_listing_id", using: :btree
  add_index "listing_details", ["location"], name: "index_listing_details_on_location", using: :btree
  add_index "listing_details", ["longitude"], name: "index_listing_details_on_longitude", using: :btree
  add_index "listing_details", ["price"], name: "index_listing_details_on_price", using: :btree
  add_index "listing_details", ["zipcode"], name: "index_listing_details_on_zipcode", using: :btree

  create_table "listing_images", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "image",       default: ""
    t.integer  "order_num"
    t.string   "caption",     default: ""
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "description", default: ""
    t.string   "category",    default: ""
    t.integer  "pickup_id"
  end

  add_index "listing_images", ["listing_id"], name: "index_listing_images_on_listing_id", using: :btree
  add_index "listing_images", ["pickup_id"], name: "index_listing_images_on_pickup_id", using: :btree

  create_table "listing_languages", force: :cascade do |t|
    t.integer  "listing_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "listing_languages", ["language_id"], name: "index_listing_languages_on_language_id", using: :btree
  add_index "listing_languages", ["listing_id"], name: "index_listing_languages_on_listing_id", using: :btree

  create_table "listing_pickups", force: :cascade do |t|
    t.integer  "listing_id"
    t.integer  "pickup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "listing_pickups", ["listing_id"], name: "index_listing_pickups_on_listing_id", using: :btree
  add_index "listing_pickups", ["pickup_id"], name: "index_listing_pickups_on_pickup_id", using: :btree

  create_table "listing_pvs", force: :cascade do |t|
    t.integer  "listing_id"
    t.date     "viewed_at"
    t.integer  "pv",         default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "listing_pvs", ["listing_id"], name: "index_listing_pvs_on_listing_id", using: :btree
  add_index "listing_pvs", ["viewed_at", "listing_id"], name: "index_listing_pvs_on_viewed_at_and_listing_id", unique: true, using: :btree

  create_table "listing_videos", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "video",      default: ""
    t.integer  "order_num"
    t.string   "caption",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "listing_videos", ["listing_id"], name: "index_listing_videos_on_listing_id", using: :btree

  create_table "listings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "review_count",                                    default: 0
    t.float    "ave_total",                                       default: 0.0
    t.float    "ave_accuracy",                                    default: 0.0
    t.float    "ave_communication",                               default: 0.0
    t.float    "ave_cleanliness",                                 default: 0.0
    t.float    "ave_location",                                    default: 0.0
    t.float    "ave_check_in",                                    default: 0.0
    t.float    "ave_cost_performance",                            default: 0.0
    t.boolean  "open",                                            default: false
    t.string   "zipcode"
    t.string   "location",                                        default: ""
    t.decimal  "longitude",               precision: 9, scale: 6, default: 0.0
    t.decimal  "latitude",                precision: 9, scale: 6, default: 0.0
    t.boolean  "delivery_flg",                                    default: false
    t.integer  "price",                                           default: 0
    t.text     "description",                                     default: ""
    t.string   "title",                                           default: ""
    t.integer  "capacity",                                        default: 0
    t.text     "direction",                                       default: ""
    t.string   "cover_image",                                     default: ""
    t.string   "cover_image_caption",                             default: ""
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.text     "cover_video",                                     default: ""
    t.text     "cover_video_description",                         default: ""
    t.text     "overview",                                        default: ""
    t.text     "notes",                                           default: ""
    t.string   "recommend1",                                      default: ""
    t.string   "recommend2",                                      default: ""
    t.string   "recommend3",                                      default: ""
    t.datetime "soft_destroyed_at"
    t.string   "interview1",                                      default: ""
    t.string   "interview2",                                      default: ""
    t.string   "interview3",                                      default: ""
  end

  add_index "listings", ["capacity"], name: "index_listings_on_capacity", using: :btree
  add_index "listings", ["latitude"], name: "index_listings_on_latitude", using: :btree
  add_index "listings", ["location"], name: "index_listings_on_location", using: :btree
  add_index "listings", ["longitude"], name: "index_listings_on_longitude", using: :btree
  add_index "listings", ["price"], name: "index_listings_on_price", using: :btree
  add_index "listings", ["title"], name: "index_listings_on_title", using: :btree
  add_index "listings", ["user_id"], name: "index_listings_on_user_id", using: :btree
  add_index "listings", ["zipcode"], name: "index_listings_on_zipcode", using: :btree

  create_table "message_thread_users", force: :cascade do |t|
    t.integer  "message_thread_id", null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "message_thread_users", ["message_thread_id", "user_id"], name: "index_message_thread_users_on_message_thread_id_and_user_id", unique: true, using: :btree
  add_index "message_thread_users", ["message_thread_id"], name: "index_message_thread_users_on_message_thread_id", using: :btree
  add_index "message_thread_users", ["user_id"], name: "index_message_thread_users_on_user_id", using: :btree

  create_table "message_threads", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "host_id"
    t.boolean  "reply_from_host",   default: false
    t.boolean  "first_message",     default: true
    t.boolean  "noticemail_sended", default: false
    t.string   "type"
    t.integer  "reservation_id"
  end

  add_index "message_threads", ["host_id"], name: "index_message_threads_on_host_id", using: :btree
  add_index "message_threads", ["reservation_id"], name: "index_message_threads_on_reservation_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "message_thread_id",                  null: false
    t.integer  "from_user_id",                       null: false
    t.integer  "to_user_id",                         null: false
    t.text     "content",            default: "",    null: false
    t.boolean  "read",               default: false
    t.datetime "read_at"
    t.integer  "listing_id",         default: 0,     null: false
    t.integer  "reservation_id",     default: 0,     null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "attached_file"
    t.string   "attached_extension"
    t.string   "attached_name"
    t.boolean  "friends_request",    default: false
  end

  add_index "messages", ["from_user_id"], name: "index_messages_on_from_user_id", using: :btree
  add_index "messages", ["listing_id"], name: "index_messages_on_listing_id", using: :btree
  add_index "messages", ["message_thread_id"], name: "index_messages_on_message_thread_id", using: :btree
  add_index "messages", ["reservation_id"], name: "index_messages_on_reservation_id", using: :btree
  add_index "messages", ["to_user_id"], name: "index_messages_on_to_user_id", using: :btree

  create_table "ngevent_weeks", force: :cascade do |t|
    t.integer  "listing_id",             null: false
    t.integer  "dow",                    null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "mode",       default: 0, null: false
    t.integer  "user_id"
  end

  add_index "ngevent_weeks", ["dow"], name: "index_ngevent_weeks_on_dow", using: :btree
  add_index "ngevent_weeks", ["listing_id"], name: "index_ngevent_weeks_on_listing_id", using: :btree

  create_table "ngevents", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "reservation_id"
    t.integer  "listing_id"
    t.date     "start",                           null: false
    t.date     "end",                             null: false
    t.date     "end_bk"
    t.integer  "mode",           default: 0,      null: false
    t.string   "color",          default: "gray"
    t.integer  "active",         default: 1
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "guest_id"
  end

  add_index "ngevents", ["mode"], name: "index_ngevents_on_mode", using: :btree
  add_index "ngevents", ["reservation_id"], name: "index_ngevents_on_reservation_id", using: :btree
  add_index "ngevents", ["user_id"], name: "index_ngevents_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "reservation_id"
    t.string   "token",            default: ""
    t.string   "payer_id",         default: ""
    t.string   "payers_status",    default: ""
    t.string   "transaction_id",   default: ""
    t.decimal  "amount"
    t.string   "currency_code",    default: ""
    t.string   "email",            default: ""
    t.string   "first_name",       default: ""
    t.string   "last_name",        default: ""
    t.string   "country_code",     default: ""
    t.datetime "transaction_date"
    t.datetime "refund_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",           default: 0
    t.decimal  "exchange_rate"
  end

  add_index "payments", ["reservation_id"], name: "index_payments_on_reservation_id", using: :btree

  create_table "pickup_areas", force: :cascade do |t|
    t.string   "short_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "cover_image"
    t.integer  "selected_listing"
    t.string   "cover_image_small", default: ""
    t.string   "long_name",         default: ""
  end

  create_table "pickup_categories", force: :cascade do |t|
    t.string   "short_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "cover_image"
    t.integer  "selected_listing"
    t.string   "cover_image_small", default: ""
    t.string   "long_name",         default: ""
  end

  create_table "pickup_tags", force: :cascade do |t|
    t.string   "short_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "cover_image"
    t.integer  "selected_listing"
    t.string   "cover_image_small", default: ""
    t.string   "long_name",         default: ""
  end

  create_table "pickups", force: :cascade do |t|
    t.string   "short_name",        default: ""
    t.string   "cover_image",       default: ""
    t.integer  "selected_listing"
    t.string   "type"
    t.integer  "order_number"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "cover_image_small", default: ""
    t.string   "long_name",         default: ""
    t.string   "icon",              default: ""
    t.string   "icon_small",        default: ""
  end

  add_index "pickups", ["short_name"], name: "index_pickups_on_short_name", using: :btree
  add_index "pickups", ["type"], name: "index_pickups_on_type", using: :btree

  create_table "pre_mails", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "email",           default: ""
    t.string   "first_name",      default: ""
    t.string   "last_name",       default: ""
    t.integer  "prefecture_code"
    t.string   "municipality"
  end

  add_index "pre_mails", ["user_id"], name: "index_pre_mails_on_user_id", using: :btree

  create_table "profile_banks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "name"
    t.string   "branch_name"
    t.integer  "account_type"
    t.string   "user_name"
    t.string   "number"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "paypal_account", default: ""
  end

  add_index "profile_banks", ["profile_id"], name: "index_profile_banks_on_profile_id", using: :btree
  add_index "profile_banks", ["user_id"], name: "index_profile_banks_on_user_id", using: :btree

  create_table "profile_categories", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "profile_categories", ["category_id"], name: "index_profile_categories_on_category_id", using: :btree
  add_index "profile_categories", ["profile_id"], name: "index_profile_categories_on_profile_id", using: :btree

  create_table "profile_countries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "country",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "profile_countries", ["country"], name: "index_profile_countries_on_country", using: :btree
  add_index "profile_countries", ["profile_id"], name: "index_profile_countries_on_profile_id", using: :btree
  add_index "profile_countries", ["user_id"], name: "index_profile_countries_on_user_id", using: :btree

  create_table "profile_identities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "image",      default: "",    null: false
    t.string   "caption",    default: ""
    t.boolean  "authorized", default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "profile_identities", ["profile_id"], name: "index_profile_identities_on_profile_id", using: :btree
  add_index "profile_identities", ["user_id"], name: "index_profile_identities_on_user_id", using: :btree

  create_table "profile_images", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "image",       default: "",    null: false
    t.string   "caption",     default: ""
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "cover_image", default: ""
    t.integer  "order_num"
    t.boolean  "cover_flg",   default: false
  end

  add_index "profile_images", ["profile_id"], name: "index_profile_images_on_profile_id", using: :btree
  add_index "profile_images", ["user_id"], name: "index_profile_images_on_user_id", using: :btree

  create_table "profile_keywords", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "keyword",    default: ""
    t.integer  "level"
  end

  add_index "profile_keywords", ["profile_id"], name: "index_profile_keywords_on_profile_id", using: :btree
  add_index "profile_keywords", ["user_id"], name: "index_profile_keywords_on_user_id", using: :btree

  create_table "profile_languages", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "profile_languages", ["language_id"], name: "index_profile_languages_on_language_id", using: :btree
  add_index "profile_languages", ["profile_id"], name: "index_profile_languages_on_profile_id", using: :btree

  create_table "profile_pickups", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "pickup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profile_pickups", ["pickup_id"], name: "index_profile_pickups_on_pickup_id", using: :btree
  add_index "profile_pickups", ["profile_id"], name: "index_profile_pickups_on_profile_id", using: :btree

  create_table "profile_videos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.string   "video",      default: "", null: false
    t.string   "caption",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "profile_videos", ["profile_id"], name: "index_profile_videos_on_profile_id", using: :btree
  add_index "profile_videos", ["user_id"], name: "index_profile_videos_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",                              null: false
    t.string   "first_name",           default: ""
    t.string   "last_name",            default: ""
    t.date     "birthday"
    t.integer  "gender"
    t.string   "phone",                default: ""
    t.boolean  "phone_verification",   default: false
    t.string   "zipcode",              default: ""
    t.string   "location",             default: ""
    t.text     "self_introduction",    default: ""
    t.string   "school",               default: ""
    t.string   "work",                 default: ""
    t.string   "timezone",             default: ""
    t.integer  "listing_count",        default: 0
    t.integer  "wishlist_count",       default: 0
    t.integer  "bookmark_count",       default: 0
    t.integer  "reviewed_count",       default: 0
    t.integer  "reservation_count",    default: 0
    t.float    "ave_total",            default: 0.0
    t.float    "ave_accuracy",         default: 0.0
    t.float    "ave_communication",    default: 0.0
    t.float    "ave_cleanliness",      default: 0.0
    t.float    "ave_location",         default: 0.0
    t.float    "ave_check_in",         default: 0.0
    t.float    "ave_cost_performance", default: 0.0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "country",              default: ""
    t.integer  "progress",             default: 0,     null: false
    t.string   "prefecture",           default: ""
    t.string   "municipality",         default: ""
    t.string   "other_address",        default: ""
    t.datetime "soft_destroyed_at"
    t.text     "free_field",           default: ""
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "to_user_id"
    t.integer  "from_user_id"
    t.integer  "user_type",    default: 0
    t.string   "reason",       default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "reports", ["from_user_id"], name: "index_reports_on_from_user_id", using: :btree
  add_index "reports", ["to_user_id"], name: "index_reports_on_to_user_id", using: :btree

  create_table "reservation_withdrawals", force: :cascade do |t|
    t.integer  "reservation_id", null: false
    t.integer  "withdrawal_id",  null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reservation_withdrawals", ["reservation_id"], name: "index_reservation_withdrawals_on_reservation_id", using: :btree
  add_index "reservation_withdrawals", ["withdrawal_id"], name: "index_reservation_withdrawals_on_withdrawal_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "host_id"
    t.integer  "guest_id"
    t.integer  "listing_id"
    t.datetime "schedule"
    t.integer  "num_of_people",                                  default: 0,     null: false
    t.text     "msg",                                            default: ""
    t.integer  "progress",                                       default: 0,     null: false
    t.text     "reason",                                         default: ""
    t.datetime "review_mail_sent_at"
    t.datetime "review_expiration_date"
    t.datetime "review_landed_at"
    t.datetime "reviewed_at"
    t.datetime "reply_mail_sent_at"
    t.datetime "reply_landed_at"
    t.datetime "replied_at"
    t.datetime "review_opened_at"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.decimal  "time_required",          precision: 9, scale: 6, default: 0.0
    t.integer  "price",                                          default: 0
    t.string   "place",                                          default: ""
    t.text     "description",                                    default: ""
    t.date     "schedule_end"
    t.text     "place_memo",                                     default: ""
    t.integer  "campaign_id"
    t.integer  "refund_rate",                                    default: 0
    t.integer  "price_for_support",                              default: 0
    t.integer  "price_for_both_guides",                          default: 0
    t.boolean  "space_option",                                   default: true
    t.integer  "space_rental",                                   default: 0
    t.boolean  "car_option",                                     default: true
    t.integer  "car_rental",                                     default: 0
    t.integer  "gas",                                            default: 0
    t.integer  "highway",                                        default: 0
    t.integer  "parking",                                        default: 0
    t.integer  "guests_cost",                                    default: 0
    t.text     "included_guests_cost",                           default: ""
    t.integer  "cancel_by",                                      default: 0
    t.integer  "pair_guide_id"
    t.integer  "pair_guide_status",                              default: 0
    t.boolean  "bicycle_option",                                 default: false
    t.integer  "bicycle_rental",                                 default: 0
    t.boolean  "other_option",                                   default: false
    t.integer  "other_cost",                                     default: 0
    t.integer  "insurance_fee",                                  default: 0
  end

  add_index "reservations", ["campaign_id"], name: "index_reservations_on_campaign_id", using: :btree
  add_index "reservations", ["guest_id"], name: "index_reservations_on_guest_id", using: :btree
  add_index "reservations", ["host_id"], name: "index_reservations_on_host_id", using: :btree
  add_index "reservations", ["listing_id"], name: "index_reservations_on_listing_id", using: :btree
  add_index "reservations", ["pair_guide_id"], name: "index_reservations_on_pair_guide_id", using: :btree

  create_table "review_replies", force: :cascade do |t|
    t.integer  "review_id"
    t.text     "msg",              default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "accuracy",         default: 0
    t.integer  "communication",    default: 0
    t.integer  "clearliness",      default: 0
    t.integer  "location",         default: 0
    t.integer  "check_in",         default: 0
    t.integer  "cost_performance", default: 0
    t.integer  "total",            default: 0
  end

  add_index "review_replies", ["review_id"], name: "index_review_replies_on_review_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "guest_id"
    t.integer  "host_id"
    t.integer  "reservation_id"
    t.integer  "listing_id"
    t.integer  "accuracy",         default: 0
    t.integer  "communication",    default: 0
    t.integer  "clearliness",      default: 0
    t.integer  "location",         default: 0
    t.integer  "check_in",         default: 0
    t.integer  "cost_performance", default: 0
    t.integer  "total",            default: 0
    t.text     "msg",              default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "type",                          null: false
    t.string   "tour_image",       default: ""
  end

  add_index "reviews", ["guest_id"], name: "index_reviews_on_guest_id", using: :btree
  add_index "reviews", ["host_id"], name: "index_reviews_on_host_id", using: :btree
  add_index "reviews", ["listing_id"], name: "index_reviews_on_listing_id", using: :btree
  add_index "reviews", ["reservation_id"], name: "index_reviews_on_reservation_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tools", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "name",                    null: false
    t.string   "url",        default: ""
    t.string   "image",      default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "tools", ["listing_id", "name"], name: "index_tools_on_listing_id_and_name", unique: true, using: :btree
  add_index "tools", ["listing_id"], name: "index_tools_on_listing_id", using: :btree

  create_table "user_campaigns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_campaigns", ["campaign_id"], name: "index_user_campaigns_on_campaign_id", using: :btree
  add_index "user_campaigns", ["user_id"], name: "index_user_campaigns_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",                    default: "", null: false
    t.string   "provider",               default: "", null: false
    t.string   "username"
    t.datetime "soft_destroyed_at"
    t.string   "email_before_closed",    default: ""
    t.text     "reason",                 default: ""
    t.integer  "user_type",              default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "wishlists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wishlists", ["user_id", "name"], name: "index_wishlists_on_user_id_and_name", unique: true, using: :btree
  add_index "wishlists", ["user_id"], name: "index_wishlists_on_user_id", using: :btree

  create_table "withdrawals", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.integer  "amount",       default: 0, null: false
    t.datetime "requested_at"
    t.datetime "paid_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "withdrawals", ["paid_at"], name: "index_withdrawals_on_paid_at", using: :btree
  add_index "withdrawals", ["requested_at"], name: "index_withdrawals_on_requested_at", using: :btree
  add_index "withdrawals", ["user_id"], name: "index_withdrawals_on_user_id", using: :btree

  add_foreign_key "auths", "users"
  add_foreign_key "browsing_histories", "listings"
  add_foreign_key "confections", "listings"
  add_foreign_key "dress_codes", "listings"
  add_foreign_key "emergencies", "profiles"
  add_foreign_key "emergencies", "users"
  add_foreign_key "favorites", "listings"
  add_foreign_key "favorites", "users", column: "from_user_id"
  add_foreign_key "favorites", "users", column: "to_user_id"
  add_foreign_key "listing_categories", "categories"
  add_foreign_key "listing_categories", "listings"
  add_foreign_key "listing_details", "listings"
  add_foreign_key "listing_images", "listings"
  add_foreign_key "listing_images", "pickups"
  add_foreign_key "listing_languages", "languages"
  add_foreign_key "listing_languages", "listings"
  add_foreign_key "listing_pvs", "listings"
  add_foreign_key "listing_videos", "listings"
  add_foreign_key "listings", "users"
  add_foreign_key "message_thread_users", "message_threads"
  add_foreign_key "message_thread_users", "users"
  add_foreign_key "message_threads", "reservations"
  add_foreign_key "message_threads", "users", column: "host_id"
  add_foreign_key "messages", "message_threads"
  add_foreign_key "messages", "users", column: "from_user_id"
  add_foreign_key "messages", "users", column: "to_user_id"
  add_foreign_key "payments", "reservations"
  add_foreign_key "pre_mails", "users"
  add_foreign_key "profile_banks", "profiles"
  add_foreign_key "profile_banks", "users"
  add_foreign_key "profile_categories", "categories"
  add_foreign_key "profile_categories", "profiles"
  add_foreign_key "profile_countries", "profiles"
  add_foreign_key "profile_countries", "users"
  add_foreign_key "profile_identities", "profiles"
  add_foreign_key "profile_identities", "users"
  add_foreign_key "profile_images", "profiles"
  add_foreign_key "profile_images", "users"
  add_foreign_key "profile_keywords", "profiles"
  add_foreign_key "profile_keywords", "users"
  add_foreign_key "profile_languages", "languages"
  add_foreign_key "profile_languages", "profiles"
  add_foreign_key "profile_pickups", "pickups"
  add_foreign_key "profile_pickups", "profiles"
  add_foreign_key "profile_videos", "profiles"
  add_foreign_key "profile_videos", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "reports", "users", column: "from_user_id"
  add_foreign_key "reports", "users", column: "to_user_id"
  add_foreign_key "reservation_withdrawals", "reservations"
  add_foreign_key "reservation_withdrawals", "withdrawals"
  add_foreign_key "reservations", "listings"
  add_foreign_key "reservations", "users", column: "guest_id"
  add_foreign_key "reservations", "users", column: "host_id"
  add_foreign_key "reservations", "users", column: "pair_guide_id"
  add_foreign_key "review_replies", "reviews"
  add_foreign_key "reviews", "listings"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "reviews", "users", column: "guest_id"
  add_foreign_key "reviews", "users", column: "host_id"
  add_foreign_key "tools", "listings"
  add_foreign_key "user_campaigns", "campaigns"
  add_foreign_key "user_campaigns", "users"
  add_foreign_key "wishlists", "users"
  add_foreign_key "withdrawals", "users"
end
