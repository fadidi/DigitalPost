This is a demo app which offers instant support for login using:

* Facebook
* Google
* Twitter
* Traditional username/password

It's target user group is Peace Corps posts. The structure is customized to reflect their needs, and offers support for the storage, presentation, and manipulation of the following resources:

### Features

* File management
* Multimedia timeline for post history
* Volunteer profiles
* Staff profiles
* Friend & Family subscription
* Site content

#### Files

All sorts, including

* photos
* office docs
* PDFs
* spreadsheets

#### Users

Allows anyone to sign up for the site, has restricted access to certain resources based on permission groups. Allows users to be designated as volunteers or staff members, and tracks info such as COS date, sector, job position, etc.

#### Pages

Supports in-browser creation, management, and editing of 'static' pages. Has a built-in WYSIWYG editor, so almost no HTML knowledge is required.

#### Case Studies

Similar to pages, but stored separately.

#### Libraries

Libraries allow users to build collections of files, pages, case studies, photos, and users around any theme, and then access or download the resources as a group.

## Requirements


## S3 and Local Storage

S3 is the default production storage location, but the Paperclip attachment gem is configured in the various environment files (config/environments/production.rb, development.rb, test.rb) to store files locally for testing and development. There is a special directory structure, "public/system/#{Rails.env}/:attachment/:id/:style/:filename", used to avoid mingling between the environments, and allow clearing out of the test files after testing. 

## Installation on Heroku

#### Purchase and Configure Domain

#### Pick a Heroku app name

#### Set up Amazon S3

Need a bucket name, key, and secret

#### Set up Amazon Route 53 (should be optional, but need to set up DNS)

Need root domain pointing to Heroku IP, subs pointing to heroku appname

#### Branch / clone app from Git

#### Configure code

Set up MailGun settings. You need to edit the domain property, and use your Heroku domain. For example, our app is running at pcsenegal-production.herokuapp.com. That's what you use for the domain.

    # app/environments/production.rb

    ActionMailer::Base.smtp_settings = {
      :port           => ENV['MAILGUN_SMTP_PORT'], 
      :address        => ENV['MAILGUN_SMTP_SERVER'],
      :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
      :password       => ENV['MAILGUN_SMTP_PASSWORD'],
      :domain         => '<your heroku domain here>',
      :authentication => :plain,
    }
    ActionMailer::Base.delivery_method = :smtp

Configure the host in Devise's confirmation mailer. This time use your forward-facing domain. For us, it's www.pcsenegal.org.

    # app/views/devise/mailer/confirmation_instructions.html.erb

    <p><%= link_to 'Confirm my account', confirmation_url(@resource, :host => '<your domain here>', :confirmation_token => @resource.confirmation_token) %></p>

#### Create Heroku App

    heroku create -r <remote name> <appname>

#### Push app to Heroku to initialize environment

    git push <branch> <remote name>:master

#### Add domain to Heroku app

    heroku domains:add <domain name> --app <appname>

#### Add Heroku Addons

    heroku addons:add mailgun:starter --app <appname>
    heroku addons:add redistogo:nano --app <appname>

#### Set config variables on Heroku app

    heroku config:add
      FB_KEY=<fb key> 
      FB_SECRET=<fb secret> 
      G_ANALYTICS_ID=<analytics id> 
      S3_BUCKET=<bucket name> 
      S3_KEY=<s3 key> 
      S3_SECRET=<s3 secret>
      BITLY_USERNAME=<bitly api username>
      BITLY_KEY=<bitly api key>

#### Create and seed the database

    heroku run rake db:migrate
    heroku run rake db:seed

#### Sign in as admin, change password

Sign is as user 'admin@example.com', password 'password'
Change the name/email/password to be whatever you want
Make sure it's secure

You're good to go!

## Testing

Rspec tests are included. To use, run bundle exec rake db:prepare_test_db, and then bundle exec rspec spec/.

# Technical Info

This application was generated with the "rails_apps_composer":https://github.com/RailsApps/rails_apps_composer gem provided by the "RailsApps Project":http://railsapps.github.com/.

## Diagnostics

This application was built with recipes that are NOT known to work together.

This application was built with preferences that are NOT known to work together.

If the application doesn't work as expected, please "report an issue":https://github.com/RailsApps/rails_apps_composer/issues and include these diagnostics:

We'd also like to know if you've found combinations of recipes or preferences that do work together.

Recipes:
["auth", "controllers", "core", "email", "extras", "frontend", "gems", "git", "init", "models", "railsapps", "readme", "routes", "setup", "testing", "views"]

Preferences:
{:git=>true, :railsapps=>"none", :dev_webserver=>"thin", :prod_webserver=>"thin", :database=>"sqlite", :templates=>"haml", :unit_test=>"rspec", :integration=>"cucumber", :fixtures=>"factory_girl", :frontend=>"bootstrap", :bootstrap=>"sass", :email=>"sendgrid", :authentication=>"devise", :devise_modules=>"invitable", :authorization=>"cancan", :starter_app=>"admin_app"}

## Ruby on Rails

This application requires:

* Ruby version 1.9.2
* Rails version 3.2.8

Learn more about "Installing Rails":http://railsapps.github.com/installing-rails.html.

## Database

This application uses PostgreSQL with ActiveRecord.

## Development

* Template Engine: Haml
* Testing Framework: RSpec and Factory Girl and Cucumber
* Front-end Framework: Twitter Bootstrap (Sass)
* Form Builder: None
* Authentication: Devise
* Authorization: CanCan

## Email

The application is configured to send email using a SendGrid account.

## Documentation and Support

This is the only documentation.

## Similar Projects

This is a spiritual successor to http://github.com/brownjohnf/pc2, and a technical successory to http://github.com/brownjohnf/PeaceCorpsAfrica.

## Contributing

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

If you add functionality to this application, create an alternative implementation, or build an application that is similar, please contact me and I'll add a note to the README so that others can find your work.

## Credits

John F. Brown

## License

Do as you please.
