require 'swagger_helper'

RSpec.describe 'api/races', type: :request, swagger_doc: 'v1/swagger.yaml' do
  let(:user) { User.create!(email: 'api@user.com', password: 'Password.123') }
  let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }

  path '/api/tracks/{track_id}/races' do

    get 'Lista wyścigów dla toru' do
      tags 'Races'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :track_id, in: :path, type: :string, description: 'ID toru'

      response '200', 'lista wyścigów znaleziona' do
        let(:track) { Track.create!(name: 'Tor testowy', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:track_id) { track.id }
        run_test!
      end

      response '404', 'tor nie znaleziony' do
        let(:track_id) { 'invalid' }
        run_test!
      end
    end

    post 'Tworzy nowy wyścig' do
      tags 'Races'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :track_id, in: :path, type: :string, description: 'ID toru'
      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          start_time: { type: :string, format: 'date-time' },
          end_time: { type: :string, format: 'date-time' }
        },
        required: [ 'name', 'start_time', 'end_time' ]
      }

      response '201', 'wyścig utworzony' do
        let(:track) { Track.create!(name: 'Tor testowy', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:track_id) { track.id }
        let(:race) { { name: 'Wyścig 1', start_time: Time.now.iso8601, end_time: (Time.now + 1.hour).iso8601 } }
        run_test!
      end

      response '422', 'błędne dane wejściowe' do
        let(:track) { Track.create!(name: 'Tor testowy', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:track_id) { track.id }
        let(:race) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/races/{id}' do

    get 'Pobiera pojedynczy wyścig' do
      tags 'Races'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string, description: 'ID wyścigu'

      response '200', 'wyścig znaleziony' do
        let(:track) { Track.create!(name: 'Tor', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:id) { Race.create!(track: track, name: 'Test Race', start_time: Time.now, end_time: Time.now + 1.hour).id }
        run_test!
      end

      response '404', 'wyścig nie znaleziony' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Aktualizuje wyścig' do
      tags 'Races'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string, description: 'ID wyścigu'
      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          start_time: { type: :string, format: 'date-time' },
          end_time: { type: :string, format: 'date-time' }
        }
      }

      response '200', 'wyścig zaktualizowany' do
        let(:track) { Track.create!(name: 'Tor', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:id) { Race.create!(track: track, name: 'Old Name', start_time: Time.now, end_time: Time.now + 1.hour).id }
        let(:race) { { name: 'Nowa nazwa' } }
        run_test!
      end
    end

    delete 'Usuwa wyścig' do
      tags 'Races'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string, description: 'ID wyścigu'

      response '204', 'wyścig usunięty' do
        let(:track) { Track.create!(name: 'Tor', location: 'Miasto', length_meters: 1000, is_indoor: false) }
        let(:id) { Race.create!(track: track, name: 'To Delete', start_time: Time.now, end_time: Time.now + 1.hour).id }
        run_test!
      end

      response '404', 'wyścig nie znaleziony' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
