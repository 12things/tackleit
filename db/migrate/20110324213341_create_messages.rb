class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :state
      t.text :text
      t.string :msg_type
      t.integer :website_id
      t.integer :user_id
      
      t.string :path
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
