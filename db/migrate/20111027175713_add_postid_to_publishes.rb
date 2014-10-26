class AddPostidToPublishes < ActiveRecord::Migration
  def self.up
	add_column "publishes", "postid", :string
	add_index "publishes", "postid"
  end

  def self.down
  end
end
