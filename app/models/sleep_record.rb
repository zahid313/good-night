class SleepRecord < ApplicationRecord
  belongs_to :user
  validates :user, :start_time, :end_time, presence: true
  before_save :calculate_duration
  validate :valid_sleep_period

  def self.ransackable_attributes(auth_object = nil)
    ["start_time", "end_time"]
  end

  def calculate_duration
    if start_time.present? && end_time.present?
      duration = (end_time - start_time) / 1.minute
      self.duration = duration.round
    end
  end
  

  private

  def valid_sleep_period
    return if start_time.blank? || end_time.blank?
    if (end_time - start_time) > 1.day
      errors.add(:end_time, "must be within 24 hours of start time")
    elsif end_time <= start_time
      errors.add(:end_time, "must be after start time")  
    end
  end  
end
