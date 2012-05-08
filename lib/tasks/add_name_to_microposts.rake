task :add_name_to_microposts => :environment do
  
    Micropost.all.each do |micropost|
      user = User.find_by_id(micropost.user_id)
      micropost.name = user.name
      micropost.save
  end
end
    