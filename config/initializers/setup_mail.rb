ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :address              => "mail.jukaela.com",
  :port                 => 26,
  :domain               => "jukaela.com",
  :user_name            => "support@jukaela.com",
  :password             => "yOkzHT8d",
  :authentication       => :login,
  :enable_starttls_auto => false
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"

