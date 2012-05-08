class AddNameToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :name, :string
  end
end
