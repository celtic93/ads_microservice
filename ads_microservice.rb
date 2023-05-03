# frozen_string_literal: true

require 'roda'

class AdsMicroservice < Roda
  plugin :json, classes: [Array, Hash]

  route do |r|
    r.root do
      'AdsMicroservice'
    end

    r.on 'ads' do
      r.get do
        { test: 'test' }
      end
    end
  end
end
