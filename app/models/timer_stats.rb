class TimerStats
  def last_completed_timer(user)
    user.timers.order("id desc").where("end_time is not null").first
  end

  def completed_counts_on(user, date)
    user.timers.where(end_time: (date.beginning_of_day)..(date.end_of_day)).count
  end
end
