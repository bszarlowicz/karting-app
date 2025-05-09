class Lap < ApplicationRecord
  belongs_to :user
  belongs_to :race

  validates :lap_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :lap_time_seconds, presence: true, numericality: { greater_than: 0 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  validates :lap_number, uniqueness: { scope: [:user_id, :race_id], message: "User can only have one lap with this number in the same race" }
end
