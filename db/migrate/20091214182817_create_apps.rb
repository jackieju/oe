class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.integer :creator
      t.integer :appkey
      t.string :secret
      t.integer :permission
      t.integer :style
      t.integer :type
      t.string :name
      t.string :desc
      t.string :callback

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
