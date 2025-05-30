# frozen_string_literal: true
require 'swagger_helper'

RSpec.describe 'api/tracks', type: :request, swagger_doc: 'v1/swagger.yaml' do
  let(:user) { User.create!(email: 'api@user.com', password: 'Password.123') }
  let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }

  path '/api/tracks' do
    get 'List all tracks' do
      tags 'Tracks'
      produces 'application/json'
      security [bearerAuth: []]
        
      response '200', 'tracks listed' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            location: { type: :string },
            length_meters: { type: :number },
            is_indoor: { type: :boolean }
          }
        }

        before do
          Track.create!(name: 'Tor Kraków', location: 'Kraków', length_meters: 600, is_indoor: false)
        end

        run_test!
      end
    end

    post 'Create a track' do
      tags 'Tracks'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :track, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          location: { type: :string },
          length_meters: { type: :number },
          is_indoor: { type: :boolean }
        },
        required: %w[name location length_meters is_indoor]
      }

      response '201', 'track created' do
        let(:track) do
          {
            name: 'Autodrom',
            location: 'Warszawa',
            length_meters: 700,
            is_indoor: true
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:track) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/tracks/{id}' do

    parameter name: :id, in: :path, type: :string, required: true

    get 'Show a track' do
      security [bearerAuth: []]
      tags 'Tracks'
      produces 'application/json'

      response '200', 'track found' do
        let(:id) { Track.create!(name: 'Test Track', location: 'Test City', length_meters: 400, is_indoor: false).id }
        run_test!
      end

      response '404', 'track not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a track' do
      tags 'Tracks'
      consumes 'application/json'
      security [bearerAuth: []]  
      parameter name: :track, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          location: { type: :string },
          length_meters: { type: :number },
          is_indoor: { type: :boolean }
        }
      }

      response '200', 'track updated' do
        let(:id) { Track.create!(name: 'Old Name', location: 'Old City', length_meters: 350, is_indoor: false).id }
        let(:track) { { name: 'New Name' } }
        run_test!
      end
    end

    delete 'Delete a track' do
      security [bearerAuth: []]  
      tags 'Tracks'

      response '204', 'track deleted' do
        let(:id) { Track.create!(name: 'Delete Track', location: 'Delete City', length_meters: 450, is_indoor: true).id }
        run_test!
      end

      response '404', 'track not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
