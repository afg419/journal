module ChartParamsService
  def datetime_params
    if (start = params["start_date"]) && (finish = params["end_date"])
      start_date = Time.strptime(start, "%m/%d/%Y")
      end_date =  Time.strptime(finish, "%m/%d/%Y")
    else
      start_date = current_user.first_entry_date
      end_date =  current_user.last_entry_date
    end
      [start_date, end_date]
  end

  def emotion_params
    return [] unless params["emotions"]
    params["emotions"].to_a.map do |emotion, value|
      if value.to_i == 1
        current_user.active_emotion_prototypes.find{|emp| emp.name == emotion}
      end
    end.compact
  end

  def time_interval
    return {start: nil, end: nil} unless params["emotions"]
    num = params["emotions"]["days"].to_i
    end_time = current_user.last_entry_date
    start_time = end_time - num.days
    {start: start_time.to_i * 1000, end: end_time.to_i * 1000}
  end

  def emotion_names
    emotion_params.map{|emp| emp.name}.join(", ")
  end
end
