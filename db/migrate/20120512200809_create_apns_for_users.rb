class CreateApnsForUsers < ActiveRecord::Migration
  def change
      create_table :apns do |t|
        t.string    :device_token,          :null => false, :limit => 64
        t.timestamps
      end
  end
end
