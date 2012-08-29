task :add_info_to_mentions => :environment do
Mention.all.each do |mention|
user = User.find_by_id(mention.sender_user_id)

if user.email
mention.sender_email = user.email
mention.sender_name = user.name
mention.sender_username = user.username
mention.save
end
end
end