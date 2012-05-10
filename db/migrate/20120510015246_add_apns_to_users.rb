class AddApnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apns, :string
  end
end
