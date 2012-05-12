class AddUserIdToApns < ActiveRecord::Migration
  def change
    add_column :apns, :user_id, :integer
  end
end
