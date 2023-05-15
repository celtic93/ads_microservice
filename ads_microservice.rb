# frozen_string_literal: true

require 'roda'
require 'sequel'
require 'jsonapi/serializer'

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].sort.each do |path|
  require path
end
require_relative 'db'
require_relative 'models'
require_relative 'i18n'

class AdsMicroservice < Roda
  include ApiErrors
  include PaginationLinks

  PER_PAGE = 25

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
        page = r.params['page'] ? r.params['page'].to_i : 1

        ads = Ad.order(Sequel.desc(:updated_at)).paginate(page, PER_PAGE)
        AdSerializer.new(ads, links: pagination_links(ads)).serializable_hash.to_json
      end

      r.post do
        ad = Ad.create(
          title: r.params.dig('ad', 'title'),
          description: r.params.dig('ad', 'description'),
          city: r.params.dig('ad', 'city'),
          user_id: r.params.dig('ad', 'user_id')
        )

        response.status = 201
        AdSerializer.new(ad).serializable_hash.to_json
      end
    end
  end
end
