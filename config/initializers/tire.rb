Tire.configure do
    url ENV['SEARCHBOX_URL'] if Rails.env.production?
    Tire::Model::Search.index_prefix('test') if Rails.env.test?

    # set a single index to use
    ELASTICSEARCH_INDEX = "#{ENV['COUNTRY'].parameterize}_elasticsearch_index"
end
