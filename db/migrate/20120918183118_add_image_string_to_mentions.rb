class AddImageStringToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :image_url, :string
  end
end
