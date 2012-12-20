task :add_send_email_to_users => :environment do
    
    User.all.each do |user|        
        user.send_email = true
        user.save
    end
end
