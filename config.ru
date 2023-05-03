# frozen_string_literal: true

dev = ENV['RACK_ENV'] == 'development'

require 'rack/unreloader'

# Initialise the Unloader while passing the subclasses to unload
# every time it detects changes
Unreloader = Rack::Unreloader.new(subclasses: %w[Roda]) { AdsMicroservice }
Unreloader.require './ads_microservice.rb'

# Pass the favicon.ico location
use Rack::Static, urls: ['/favicon.ico']

run(dev ? Unreloader : AdsMicroservice)
