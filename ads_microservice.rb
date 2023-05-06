# frozen_string_literal: true

require 'roda'
require 'sequel'

Dir["#{File.dirname(__FILE__)}/app/serializers/*.rb"].sort.each do |path|
  require path
end
require_relative 'api_errors'
require_relative 'db'
require_relative 'models'
require_relative 'i18n'

class AdsMicroservice < Roda
  include ApiErrors

  plugin :json, classes: [Array, Hash]

  plugin :error_handler do |error|
    error_object = handle_exception(error)

    response.status = error_object[:status]
    response.write(error_object[:errors].to_json)
  end

  route do |r|
    r.root do
      'AdsMicroservice'
    end

    r.on 'ads' do
      r.get do
        { count: Ad.count }
      end
    end
  end
end
