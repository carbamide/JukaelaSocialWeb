class RemoveLikesFromMicroposts < ActiveRecord::Migration
    def change
        remove_column :microposts, :likes
    end
end
