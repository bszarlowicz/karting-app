require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'password',
      first_name: 'Test',
      last_name: 'User',
      birthdate: '1990-01-01'
    )
  end

  it 'authenticates with valid credentials' do
    post '/api/login', params: { email: 'user@example.com', password: 'password' }
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body)).to have_key('token')
  end

  it 'fails with invalid credentials' do
    post '/api/login', params: { email: 'user@example.com', password: 'wrongpass' }
    expect(response).to have_http_status(:unauthorized)
  end
end
