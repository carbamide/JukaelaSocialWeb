class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.string :content
      t.integer :sender_user_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :mentions, [:user_id, :sender_user_id, :created_at]
  end
end
