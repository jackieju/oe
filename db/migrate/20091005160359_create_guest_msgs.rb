class CreateGuestMsgs < ActiveRecord::Migration
  def self.up
    create_table :guest_msgs do |t|
      t.integer :uid
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :guest_msgs
  end
end
