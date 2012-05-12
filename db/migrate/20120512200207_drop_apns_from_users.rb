class DropApnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :apns
  end

end
