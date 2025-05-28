require 'rails_helper'

RSpec.describe 'Tracks API', type: :request do
  let(:user) { User.create(email: 'test@example.com',password: 'Test123.',first_name: 'Test',last_name: 'User',birthdate: Date.new(2000, 1, 1), role_mask: "A") }

  before do
    post '/api/login', params: { email: user.email, password: 'Test123.' }
    @token = JSON.parse(response.body)['token']
    @headers = { 'Authorization' => "Bearer #{@token}" }
  end

  it 'creates a track' do
    post '/api/tracks', params: { track: { name: 'Track 1', location: "Krakow", is_indoor: true, length_meters: 250 } }, headers: @headers
    expect(response).to have_http_status(:created)
  end
end
