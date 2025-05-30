require 'swagger_helper'

RSpec.describe 'api/sessions', type: :request do
  path '/api/sessions/login' do
    post 'Log in a user' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        required: %w[email password],
        properties: {
          email: { type: :string },
          password: { type: :string }
        }
      }

      response '200', 'login successful' do
        let(:credentials) do
          {
            email: 'login@example.com',
            password: 'secret123'
          }
        end

        before do
          User.create!(
            email: 'login@example.com',
            password: 'secret123',
            password_confirmation: 'secret123',
            first_name: 'Test',
            last_name: 'User',
            birthdate: '1990-01-01',
            role_mask: 1
          )
        end

        run_test!
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'bad@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/api/sessions/logout' do
    delete 'Log out a user' do
      tags 'Sessions'
      security [bearerAuth: []]

      response '200', 'logout successful' do
        let(:Authorization) do
          user = User.create!(
            email: 'logout@example.com',
            password: 'secret123',
            password_confirmation: 'secret123',
            first_name: 'Logout',
            last_name: 'User',
            birthdate: '1991-01-01',
            role_mask: 2
          )
          user.set_token
          "Bearer #{user.token}"
        end

        run_test!
      end

      response '401', 'invalid token' do
        let(:Authorization) { 'Bearer invalidtoken' }
        run_test!
      end
    end
  end
end
