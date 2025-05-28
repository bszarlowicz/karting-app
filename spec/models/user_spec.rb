require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      first_name: 'Test',
      last_name: 'User',
      birthdate: Date.new(2000, 1, 1)
    )
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(
      password: 'password123',
      first_name: 'Test',
      last_name: 'User',
      birthdate: Date.new(2000, 1, 1)
    )
    expect(user).not_to be_valid
  end
end
