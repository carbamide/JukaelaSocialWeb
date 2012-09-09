task :add_original_poster_id_to_micropost => :environment do

Micropost.all.each do |micropost|
user = User.find_by_email(micropost.email)

if micropost.repost_name
micropost.original_poster_id = user.id
micropost.save
end
end
end

