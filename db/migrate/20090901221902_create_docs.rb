class CreateDocs < ActiveRecord::Migration
  def self.up
    create_table :docs do |t|
      t.integer :uid
      t.string :title
      t.integer :doctype
      t.string :tags
      t.string :prop

      t.timestamps
    end
  end

  def self.down
    drop_table :docs
  end
end
