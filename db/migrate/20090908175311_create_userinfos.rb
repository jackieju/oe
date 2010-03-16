class CreateUserinfos < ActiveRecord::Migration
  def self.up
    create_table :userinfos do |t|
      t.integer :id, :limit=>8
	  t.integer :uid, :limit=>8
      t.text :prop

      t.timestamps
    end
  end

  def self.down
    drop_table :userinfos
  end
end
