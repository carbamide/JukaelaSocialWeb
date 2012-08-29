class AddStuffToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :sender_email, :string
    add_column :mentions, :sender_name, :string
    add_column :mentions, :sender_username, :string
  end
end
