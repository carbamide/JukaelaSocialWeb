class AddMicropostIdToLikeUser < ActiveRecord::Migration
  def change
      add_column :like_users, :micropost_id, :integer

  end
end
