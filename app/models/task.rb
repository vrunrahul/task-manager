class Task < ApplicationRecord
  include AASM

  belongs_to :user

  validates :name, :status, :start_date, :end_date, presence: true

  validate :validate_start_date

  aasm :status do
    state :in_progress, initial: true
    state :backlog, :done

    event :backlog do
      transitions from: :in_progress, to: :backlog
    end

    event :in_progress do
      transitions from: :backlog, to: :in_progress
    end

    event :done do
      transitions from: :in_progress, to: :done
    end
  end

  class << self

    def send_alert_one_day_before
      tasks = Task.where.not(status: 'done').where(end_date: Date.today + 1)
    end

    def send_alert_one_hour_before
      tasks = Task.where.not(status: 'done').where(end_date: Date.today)
      tasks.group_by(&:user_id).each do |u_id, tasks|
        u = User.find(u_id)
        UserEmailer.send_deadline_alerts(u.email, tasks)
      end
    end
  end

  private

  def validate_start_date
    if start_date < Date.today
      errors.add(:start_date, 'Must be greater than or equal to todays date')
    elsif start_date > end_date
      errors.add(:start_date, 'Must be less than end date')
    end
  end
end
