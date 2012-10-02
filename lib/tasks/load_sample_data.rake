namespace :db do
  task :load_sample_data => :environment do
    puts 'SETTING UP SAMPLE USERS...'
    User.create!([{
      :name => 'Iffy Izeh',
      :email => 'iezeh@peacecorps.gov',
      :password => 'password',
      :password_confirmation => 'password'
    },{
      :name => 'Vanessa Dickey',
      :email => 'vdickey@peacecorps.gov',
      :password => 'password',
      :password_confirmation => 'password'
    },{
      :name => 'Mbouille Diallo',
      :email => 'mdiallo@peacecorps.gov',
      :password => 'password',
      :password_confirmation => 'password'
    },{
      :name => 'Dr. Ulle Drame',
      :email => 'udrame@peacecorps.gov',
      :password => 'password',
      :password_confirmation => 'password'
    },{
      :name => 'Etienne Senghor',
      :email => 'esenghor@peacecorps.gov',
      :password => 'password',
      :password_confirmation => 'password'
    },{
      :name => 'Emily Schauer',
      :email => 'emily@emilyschauer.com',
      :password => 'password',
      :password_confirmation => 'password'
    }])

    Staff.create!([{
      :user_id => User.find_by_email('iezeh@peacecorps.gov').id,
      :location => 'Dakar',
      :job_description_markdown => 'Manages all the stuff at the office.',
      :job_title => 'Director of Operations',
      :unit_id => Unit.find_by_name('Administrative').id
    },{
      :user_id => User.find_by_email('vdickey@peacecorps.gov').id,
      :location => 'Dakar',
      :job_description_markdown => 'Runs programming and training units.',
      :job_title => 'Director of Programming & Training',
      :unit_id => Unit.find_by_name('Programming').id
    },{
      :user_id => User.find_by_email('mdiallo@peacecorps.gov').id,
      :location => 'Dakar/Thies',
      :job_description_markdown => 'Keeps everyone safe.',
      :job_title => 'Director of Safety & Security',
      :unit_id => Unit.find_by_name('Safety & Security').id
    },{
      :user_id => User.find_by_email('udrame@peacecorps.gov').id,
      :location => 'Dakar',
      :job_description_markdown => 'Tends to the sick.',
      :job_title => 'Medical Officer',
      :unit_id => Unit.find_by_name('Medical').id
    },{
      :user_id => User.find_by_email('esenghor@peacecorps.gov').id,
      :location => 'Thies',
      :job_description_markdown => 'Runs the training center.',
      :job_title => 'Training Center Manager',
      :unit_id => Unit.find_by_name('Training').id
    }])
    
    Volunteer.create!([{
      :user_id => User.find_by_email('emily@emilyschauer.com').id,
      :service_info_markdown => 'Did lots of stuff.',
      :local_name => 'Mariam Ba',
      :site => 'Kaffrine',
      :cos_date => '2012-10-15'
    }])

    puts 'SETTING SAMPLE USER VALID EMAIL RECORDS...'
    ValidEmail.create!([{
      :email => 'iezeh@peacecorps.gov',
      :permissions => 'staff'
    },{
      :email => 'vdickey@peacecorps.gov',
      :permissions => 'admin,staff'
    },{
      :email => 'mdiallo@peacecorps.gov',
      :permissions => 'staff'
    },{
      :email => 'udrame@peacecorps.gov',
      :permissions => 'staff'
    },{
      :email => 'esenghor@peacecorps.gov',
      :permissions => 'staff'
    },{
      :email => 'web@pcsenegal.org',
      :permissions => 'admin,volunteer'
    }])

    puts 'LOADING SAMPLE STAGES...'
    Stage.create!([{
      :arrival => '2009-08-14',
      :swear_in => '2009-10-15',
      :anticipated_cos => '2011-10-15'
    },{
      :arrival => '2010-03-15',
      :swear_in => '2010-05-15',
      :anticipated_cos => '2012-05-15'
    },{
      :arrival => '2010-08-19',
      :swear_in => '2010-10-18',
      :anticipated_cos => '2012-10-18'
    },{
      :arrival => '2011-02-05',
      :swear_in => '2011-04-05',
      :anticipated_cos => '2013-04-05'
    },{
      :arrival => '2011-05-10',
      :swear_in => '2011-07-10',
      :anticipated_cos => '2013-07-10'
    }])

    puts 'LOADING SAMPLE WORK ZONES...'
    WorkZone.create!([{
      :name => 'Toubacouta',
      :abbreviation => 'TBKTA',
      :region_id => 1
    },{
      :name => 'Kaffrine',
      :abbreviation => 'KAF',
      :region_id => 2
    }])
  end
end
