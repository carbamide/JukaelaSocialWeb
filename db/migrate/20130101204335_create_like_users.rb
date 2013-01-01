class CreateLikeUsers < ActiveRecord::Migration
  def change
    create_table :like_users do |t|
      t.string :username
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
