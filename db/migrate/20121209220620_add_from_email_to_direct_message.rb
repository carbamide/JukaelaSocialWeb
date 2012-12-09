class AddFromEmailToDirectMessage < ActiveRecord::Migration
  def change
    add_column :direct_messages, :from_email, :string
  end
end
