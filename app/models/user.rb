class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_many :laps
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :birthdate, presence: true
  validate :valid_birthdate

  ROLES = {
    "S" => "standard",
    "A" => "admin"
  }

  after_create :auto_set_role, unless: :role_mask

  def auto_set_role
    update_column(:role_mask, "S") unless role_mask.present?
  end

  def set_role(role)
    unless ROLES.key?(role)
      raise ArgumentError, "Invalid role"
    end

    update!(role_mask: role)
  end

  def admin?
    role_mask == "A"
  end

  def valid_birthdate
    if birthdate.present? && birthdate > 18.years.ago.to_date
      errors.add(:birthdate, "must be at least 18 years old")
    end
  end

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

  def name
  "#{first_name} #{last_name}"
end
end
