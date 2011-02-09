# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100428074312) do

  create_table "apps", :force => true do |t|
    t.integer  "creator"
    t.integer  "appkey"
    t.string   "secret"
    t.integer  "permission"
    t.integer  "style"
    t.integer  "type"
    t.string   "name"
    t.string   "desc"
    t.string   "callback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "docs", :force => true do |t|
    t.integer  "uid"
    t.string   "title"
    t.integer  "doctype"
    t.string   "tags"
    t.string   "prop"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guest_msgs", :force => true do |t|
    t.integer  "uid"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memos", :force => true do |t|
    t.text     "content"
    t.string   "tags"
    t.integer  "uid"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "publishes", :force => true do |t|
    t.integer  "uid"
    t.string   "username"
    t.integer  "docid"
    t.string   "doctitle"
    t.string   "target"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pubsets", :force => true do |t|
    t.integer  "uid"
    t.string   "type"
    t.string   "user"
    t.string   "password"
    t.string   "email_f"
    t.string   "email_t"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userapps", :force => true do |t|
    t.integer  "uid"
    t.string   "appid"
    t.string   "appurl"
    t.string   "applogourl"
    t.string   "appname"
    t.integer  "appkey"
    t.integer  "permission"
    t.integer  "style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userinfos", :force => true do |t|
    t.integer  "uid",        :limit => 8
    t.text     "prop"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "settings"
    t.text     "blogset"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "identity_url"
  end

end
