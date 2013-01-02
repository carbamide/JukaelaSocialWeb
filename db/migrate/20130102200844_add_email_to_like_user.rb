class AddEmailToLikeUser < ActiveRecord::Migration
  def change
    add_column :like_users, :email, :string
  end
end
