class AddEmailSettingToUser < ActiveRecord::Migration
  def change
    add_column :users, :send_email, :boolean
  end
end
