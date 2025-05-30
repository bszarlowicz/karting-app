require 'swagger_helper'
RSpec.describe 'api/laps', type: :request, swagger_doc: 'v1/swagger.yaml' do
    let(:user) { User.create!(email: 'api@user.com', password: 'Password.123') }
    let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }


describe 'Laps API' do
  path '/api/races/{race_id}/laps' do
    get 'Lists all laps for a race' do
      tags 'Laps'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :race_id, in: :path, type: :string

      response '200', 'laps listed' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  lap_number: { type: :integer },
                  lap_time_seconds: { type: :number },
                  position: { type: :integer }
                },
                required: [ 'id', 'lap_number', 'lap_time_seconds', 'position' ]
              }
            }
          }

        let(:race_id) { Race.create!(name: 'Test Race', start_time: Time.now, end_time: Time.now + 1.hour, track: Track.create!(name: 'Test Track')).id }
        run_test!
      end
    end

    post 'Creates a lap for a race' do
      tags 'Laps'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :race_id, in: :path, type: :string
      parameter name: :lap, in: :body, schema: {
        type: :object,
        properties: {
          lap: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              lap_number: { type: :integer },
              lap_time_seconds: { type: :number },
              position: { type: :integer }
            },
            required: ['user_id', 'lap_number', 'lap_time_seconds', 'position']
          }
        },
        required: ['lap']
      }

      response '201', 'lap created' do
        let(:race_id) { Race.create!(name: 'Test Race', start_time: Time.now, end_time: Time.now + 1.hour, track: Track.create!(name: 'Test Track')).id }
        let(:lap) { { lap: { user_id: User.create!(email: 'a@b.com', password: 'password').id, lap_number: 1, lap_time_seconds: 65.4, position: 1 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:race_id) { 0 }
        let(:lap) { { lap: { lap_number: 1 } } }
        run_test!
      end
    end
  end

  path '/api/laps/{id}' do
    get 'Retrieves a lap' do
      tags 'Laps'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string

      response '200', 'lap found' do
        let(:id) { Lap.create!(user_id: User.create!(email: 'a@b.com', password: 'password').id, race: Race.create!(name: 'Race', start_time: Time.now, end_time: Time.now + 1.hour, track: Track.create!(name: 'Track')), lap_number: 1, lap_time_seconds: 60.0, position: 1).id }
        run_test!
      end

      response '404', 'lap not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a lap' do
      tags 'Laps'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :lap, in: :body, schema: {
        type: :object,
        properties: {
          lap: {
            type: :object,
            properties: {
              lap_time_seconds: { type: :number }
            },
            required: ['lap_time_seconds']
          }
        }
      }

      response '200', 'lap updated' do
        let(:lap_record) { Lap.create!(user_id: User.create!(email: 'a@b.com', password: 'password').id, race: Race.create!(name: 'Race', start_time: Time.now, end_time: Time.now + 1.hour, track: Track.create!(name: 'Track')), lap_number: 1, lap_time_seconds: 60.0, position: 1) }
        let(:id) { lap_record.id }
        let(:lap) { { lap: { lap_time_seconds: 59.9 } } }
        run_test!
      end
    end

    delete 'Deletes a lap' do
      tags 'Laps'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string

      response '204', 'lap deleted' do
        let(:id) { Lap.create!(user_id: User.create!(email: 'a@b.com', password: 'password').id, race: Race.create!(name: 'Race', start_time: Time.now, end_time: Time.now + 1.hour, track: Track.create!(name: 'Track')), lap_number: 1, lap_time_seconds: 60.0, position: 1).id }
        run_test!
      end
    end
  end
end
end