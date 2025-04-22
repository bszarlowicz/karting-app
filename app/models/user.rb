class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def generate_jwt
    payload = { user_id: self.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def set_token
    self.token = generate_jwt
    save
  end

  def self.valid_token?(token)
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      user = find(decoded['user_id'])
      return user if user.token == token
    rescue JWT::DecodeError => e
      return nil
    end
  end
end
