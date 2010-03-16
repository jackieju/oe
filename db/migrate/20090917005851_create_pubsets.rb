class CreatePubsets < ActiveRecord::Migration
  def self.up
    create_table :pubsets do |t|
      t.integer :uid
      t.string :type
      t.string :user
      t.string :password
      t.string :email_f
      t.string :email_t
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :pubsets
  end
end
