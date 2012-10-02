unless Rails.env.production?
  ENV['MAILGUN_SMTP_SERVER'] = ''
  ENV['MAILGUN_SMTP_PORT'] = ''
  ENV['MAILGUN_SMTP_LOGIN'] = ''
  ENV['MAILGUN_SMTP_PASSWORD'] = ''
  ENV['DOMAIN'] = 'localhost'
  ENV['COUNTRY'] = 'STAGING'
  ENV['COUNTRY_CODE'] = 'STAGE'
  ENV['FB_ID'] = ''
  ENV['FB_KEY'] = ''
  ENV['FB_URL'] = ''
  ENV['TWITTER_URL'] = ''
end
