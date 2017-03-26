require "#{Rails.root}/app/validators/time_overwrap_validator"

class Timer < ActiveRecord::Base
  INITIAL_TIME = 10#25 * 60

  belongs_to :user

  class Status
    include Ruby::Enum

    define :INITIAL,   "INITIAL"
    define :RUNNING,   "RUNNING"
    define :PAUSED,    "PAUSED"
    define :COMPLETED, "COMPLETED"
  end

  paginates_per 50

  has_many :pauses, dependent: :destroy

  validates_with ::TimeOverlapValidator

  class << self
    def current_timer(user)
      timer = Timer.where(user: user).order("id desc").first
      if (timer.nil? || timer.status == Status::COMPLETED) && timer.try(:desc).present?
        Timer.new
      else
        timer
      end
    end

    def start(user)
      return false if Timer.current_timer(user).active?
      Timer.create(start_time: Time.zone.now, user: user)
    end
  end

  def active?
    [Status::RUNNING, Status::PAUSED].include?(status)
  end

  def stop
    return false unless status == Status::PAUSED
    stop!
  end

  def stop!
    update!(end_time: Time.zone.now)
    complete_pauses
  end

  def pause
    return false unless status == Status::RUNNING
    pauses.create!(start_time: Time.zone.now)
  end

  def resume
    return false unless status == Status::PAUSED
    complete_pauses
  end

  def status
    if start_time.nil?
      Status::INITIAL
    else
      if !end_time.nil?
        Status::COMPLETED
      else
        paused? ? Status::PAUSED : Status::RUNNING
      end
    end
  end

  def passed_seconds
    return 0 unless start_time
    ((end_time || Time.zone.now) - start_time).to_i
  end

  def remaining_seconds
    case status
    when Status::INITIAL   then INITIAL_TIME
    when Status::RUNNING   then calculate_remaining_seconds
    when Status::PAUSED    then calculate_remaining_seconds
    when Status::COMPLETED then 0
    end
  end

  def need_desc?
    (status == Timer::Status::COMPLETED) && desc.empty?
  end

  private

  def calculate_remaining_seconds
    paused    = pauses.reduce(0) { |a, e| a + e.duration }
    remaining = INITIAL_TIME - (passed_seconds - paused)

    [remaining, 0].max
  end

  def complete_pauses
    pauses.each(&:complete)
  end

  def paused?
    pauses.any?(&:active?)
  end
end
