class CreateUserapps < ActiveRecord::Migration
  def self.up
    create_table :userapps do |t|
      t.integer :uid
      t.string  :appid
      t.string  :appurl
	  t.string  :applogourl
      t.string  :appname
      t.integer :appkey
      t.integer :permission
      t.integer :style

      t.timestamps
    end
  end

  def self.down
    drop_table :userapps
  end
end
