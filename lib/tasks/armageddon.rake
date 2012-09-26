namespace :db do
  task :armageddon => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['db:test:prepare'].invoke
    Rails.env = ENV['RAILS_ENV'] = 'test'
    Rake::Task['db:seed'].invoke
  end
end
