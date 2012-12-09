class CreateDirectMessages < ActiveRecord::Migration
  def change
    create_table :direct_messages do |t|
      t.string :content
      t.string :from_username
      t.integer :from_user_id
      t.string :from_name
      t.integer :user_id
        
      t.timestamps
    end
  end
end
