class AlterApnDevices < ActiveRecord::Migration # :nodoc:

  def self.up
    drop_table :apn_notifications
  end

end
