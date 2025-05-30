require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  path '/api/users' do
    get 'List all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users listed' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            first_name: { type: :string },
            last_name: { type: :string },
            birthdate: { type: :string, format: :date },
            role_mask: { type: :integer }
          }
        }

        before do
          User.create!(
            email: 'user@example.com',
            first_name: 'Jan',
            last_name: 'Kowalski',
            password: 'password123',
            password_confirmation: 'password123',
            birthdate: '1990-01-01',
            role_mask: 1
          )
        end

        run_test!
      end
    end

    post 'Create a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        required: %w[email first_name last_name birthdate password password_confirmation],
        properties: {
          email: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          birthdate: { type: :string, format: :date },
          password: { type: :string },
          password_confirmation: { type: :string },
          role_mask: { type: :integer }
        }
      }

      response '201', 'user created' do
        let(:user) do
          {
            email: 'nowy@example.com',
            first_name: 'Nowy',
            last_name: 'Użytkownik',
            birthdate: '1995-05-15',
            password: 'secret123',
            password_confirmation: 'secret123',
            role_mask: 1
          }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: '' } }
        run_test!
      end
    end
  end

  path '/api/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Show user details' do
      tags 'Users'
      produces 'application/json'

      response '200', 'user found' do
        let(:id) do
          User.create!(
            email: 'findme@example.com',
            first_name: 'Find',
            last_name: 'Me',
            birthdate: '1985-10-10',
            password: 'password123',
            password_confirmation: 'password123',
            role_mask: 2
          ).id
        end

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          birthdate: { type: :string, format: :date },
          password: { type: :string },
          password_confirmation: { type: :string },
          role_mask: { type: :integer }
        }
      }

      response '200', 'user updated' do
        let(:id) do
          User.create!(
            email: 'update@example.com',
            first_name: 'Update',
            last_name: 'User',
            birthdate: '1992-03-10',
            password: 'password123',
            password_confirmation: 'password123',
            role_mask: 1
          ).id
        end

        let(:user) { { first_name: 'Zmieniony' } }

        run_test!
      end
    end

    delete 'Delete a user' do
      tags 'Users'

      response '204', 'user deleted' do
        let(:id) do
          User.create!(
            email: 'delete@example.com',
            first_name: 'Delete',
            last_name: 'Me',
            birthdate: '1990-02-02',
            password: 'password123',
            password_confirmation: 'password123',
            role_mask: 1
          ).id
        end

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
