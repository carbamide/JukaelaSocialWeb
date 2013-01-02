class CreateApids < ActiveRecord::Migration
  def change
    create_table :apids do |t|
      t.string :device_token
      t.integer :user_id

      t.timestamps
    end
  end
end
