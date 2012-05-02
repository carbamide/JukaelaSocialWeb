class AddUsernamePreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_username, :boolean
  end
end
