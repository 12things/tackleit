class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :title
      t.integer :messages_count, :default => 0
      t.string :email
      t.string :host
      t.boolean :verified, :default => false
      
      t.integer :company_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :websites
  end
end
