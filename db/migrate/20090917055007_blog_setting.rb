class BlogSetting < ActiveRecord::Migration
  def self.up
	add_column :userinfos, :blogset, :text
  end

  def self.down
	remove_column :userinfos, :blogset
  end
end
