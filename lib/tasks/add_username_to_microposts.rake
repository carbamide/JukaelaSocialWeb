task :add_username_to_microposts => :environment do
  
    Micropost.all.each do |micropost|
      user = User.find_by_id(micropost.user_id)
      
      if user.username
        micropost.username = user.username
        micropost.save
      end
  end
end
