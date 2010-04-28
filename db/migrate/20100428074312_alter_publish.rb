class AlterPublish < ActiveRecord::Migration
  def self.up
	rename_column("publishes","to","target")
  end

  def self.down
	rename_column("publishes","target","to")
  end
end
