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

ActiveRecord::Schema.define(:version => 20121013235306) do

  create_table "xhive_pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.string   "slug"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "site_id"
  end

  add_index "xhive_pages", ["site_id"], :name => "index_xhive_pages_on_site_id"

  create_table "xhive_sites", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "home_page_id"
  end

end
