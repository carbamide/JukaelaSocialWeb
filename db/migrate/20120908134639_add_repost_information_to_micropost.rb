class AddRepostInformationToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :repost_user_id, :integer
    add_column :microposts, :repost_name, :string
    add_column :microposts, :repost_username, :string
  end
end
