class Userinfo < ActiveRecord::Migration
  def self.up
	add_column :userinfos, :settings, :text
  end

  def self.down
remove_column :userinfos, :settings
  end
end
