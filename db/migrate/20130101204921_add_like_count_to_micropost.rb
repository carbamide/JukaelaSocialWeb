class AddLikeCountToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :likes, :integer
  end
end
