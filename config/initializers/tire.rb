Tire.configure do
    url ENV['SEARCHBOX_URL'] if Rails.env.production?

    # set a single index to use
    ELASTICSEARCH_INDEX = Rails.env.test? ? "digipost-test" : "digipost-#{ENV['COUNTRY_CODE'].parameterize}"

    # create a special testing index
    # only works if not setting an app-wide index
    #Tire::Model::Search.index_prefix('test') if Rails.env.test?
end
