# frozen_string_literal: true

# Set RACK_ENV to test.
ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'sequel'
require 'factory_bot'
require 'jsonapi/serializer'

# Load all factories defined in spec/factories folder.
FactoryBot.find_definitions

# Require all files in spec/support folder.
root_path = Pathname.new(File.expand_path('..', __dir__))
Dir[root_path.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include ApiHelpers,          type: :request

  # Include FactoryBot helper methods.
  config.include FactoryBot::Syntax::Methods

  config.include(
    Module.new do
      def app
        App.freeze.app
      end
    end
  )

  database = 'ads_microservice_test'
  user     = ENV['PGUSER']
  password = ENV['PGPASSWORD']
  Sequel.connect(adapter: 'postgres', database: database, host: '127.0.0.1', user: user, password: password)

  # Configuration for database cleaning strategy using Sequel.
  config.around do |example|
    Sequel::Model.db.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
