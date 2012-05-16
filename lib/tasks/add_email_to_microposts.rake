task :add_email_to_microposts => :environment do
  
    Micropost.all.each do |micropost|
      user = User.find_by_id(micropost.user_id)
      
      if user.email
        micropost.email = user.email
        micropost.save
      end
  end
end
