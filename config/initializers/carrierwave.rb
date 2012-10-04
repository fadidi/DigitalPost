CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],       # required
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],       # required
    #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['AWS_BUCKET_NAME']                     # required, assuming it's bucket name for AWS
  config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil

  if Rails.env.production?
    config.storage = :fog
  else
    config.storage = :file
  end

  config.enable_processing = false if Rails.env.test? || Rails.env.cucumber?
end
