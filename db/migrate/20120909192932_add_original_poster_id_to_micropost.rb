class AddOriginalPosterIdToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :original_poster_id, :integer
  end
end
