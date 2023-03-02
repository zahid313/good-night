class SleepRecord < ApplicationRecord
  belongs_to :user
  validates :user, :start_time, presence: true
  before_save :calculate_duration
  
  validate :valid_sleep_period, :validate_no_overlap
  validate :one_sleep_record_per_day_per_user
  validate :no_active_sleep_record

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

  def validate_no_overlap
    if user.present? && start_time.present? && end_time.present?
      conflicts = user.sleep_records.where("(start_time <= ?) and (end_time >= ?)", end_time, start_time)
      if conflicts.any?
        errors.add(:base, "Sleep record conflicts with existing record")
      end
    end
  end

  def one_sleep_record_per_day_per_user
    if user.present? && start_time.present?
      if user.sleep_records.where(start_time: start_time.beginning_of_day..start_time.end_of_day).count > 0
        errors.add(:start_time, 'already exists for this user')
      end
    end
  end

  def no_active_sleep_record
    if user.present? 
      if user.sleep_records.where(end_time: nil).count > 0
        errors.add(:user, 'already has an active sleep record')
      end
    end
  end  

end
