class Race < ApplicationRecord
  belongs_to :track
  has_many :laps

  validates :name, presence: true, length: { maximum: 100 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  validates :name, uniqueness: { scope: [:track_id, :start_time], message: "Race with this name already exists on this track at this time" }

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
