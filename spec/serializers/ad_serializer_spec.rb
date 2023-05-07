# frozen_string_literal: true

require 'spec_helper'
require './app/serializers/ad_serializer'
require './models'

RSpec.describe AdSerializer do
  subject { described_class.new([ad], links: links) }

  let(:ad) { create(:ad) }

  let(:links) do
    {
      first: '/path/to/first/page',
      last: '/path/to/last/page',
      next: '/path/to/next/page'
    }
  end

  let(:attributes) do
    {
      title: ad.title,
      description: ad.description,
      city: ad.city,
      lat: ad.lat,
      lon: ad.lon
    }
  end

  it 'returns ad representation' do
    expect(subject.serializable_hash).to a_hash_including(
      data: [
        {
          id: ad.id.to_s,
          type: :ad,
          attributes: attributes
        }
      ],
      links: links
    )
  end
end
