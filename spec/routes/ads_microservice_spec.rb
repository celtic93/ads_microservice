# frozen_string_literal: true

require 'spec_helper'
require './ads_microservice'

RSpec.describe AdsMicroservice, type: :request do
  describe 'GET /ads' do
    before do
      create_list(:ad, 3)
    end

    it 'returns a collection of ads' do
      get '/ads'

      expect(response.status).to eq(200)
      expect(JSON(response.body)['data'].size).to eq(3)
    end
  end

  describe 'POST /ads' do
    context 'missing parameters' do
      it 'returns an error' do
        post '/ads'

        expect(response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/ads', ad: ad_params

        expect(response.status).to eq(422)
        expect(JSON(response.body)['errors']).to include({ 'detail' => ['city', ['is not present']] })
      end
    end

    context 'valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City',
          user_id: 1
        }
      end

      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/ads', ad: ad_params }
          .to change { Ad.count }.from(0).to(1)

        expect(response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/ads', ad: ad_params

        expect(JSON(response.body)['data']).to a_hash_including(
          'id' => last_ad.id.to_s,
          'type' => 'ad'
        )
      end
    end
  end
end
