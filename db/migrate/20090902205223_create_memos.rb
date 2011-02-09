class CreateMemos < ActiveRecord::Migration
  def self.up
    create_table :memos do |t|
      t.text :content
      t.string :tags
	  t.integer :uid
	  t.string :position
      t.timestamps
    end
  end

  def self.down
    drop_table :memos
  end
end
