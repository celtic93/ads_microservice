# frozen_string_literal: true

require 'roda'
require 'sequel'

require_relative 'db'
require_relative 'models'

class AdsMicroservice < Roda
  plugin :json, classes: [Array, Hash]

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
