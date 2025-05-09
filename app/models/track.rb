class Track < ApplicationRecord
  has_many :races

  validates :name, presence: true, length: { maximum: 100 }
  validates :location, presence: true, length: { maximum: 150 }
  validates :length_meters, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :is_indoor, inclusion: { in: [true, false], message: "must be true or false" }
  
  validates :name, uniqueness: { scope: :location, message: "Track with this name already exists at the same location" }
end
