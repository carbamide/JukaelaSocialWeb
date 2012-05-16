class AddEmailToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :email, :string
  end
end
