class CreatePublishes < ActiveRecord::Migration
  def self.up
    create_table :publishes do |t|
      t.integer :uid
      t.string  :username
      t.integer :docid
      t.string :doctitle
      t.string :to
      t.string :permalink
      t.timestamps
    end
  end

  def self.down
    drop_table :publishes
  end
end
