class SleepRecord < ApplicationRecord
  belongs_to :user
  validates :user, :start_time, :end_time, presence: true

  validate :valid_sleep_period

  private

  def valid_sleep_period
    if (end_time - start_time) > 1.day
      errors.add(:end_time, "must be within 24 hours of start time")
    elsif end_time <= start_time
      errors.add(:end_time, "must be after start time")  
    end
  end  
end
