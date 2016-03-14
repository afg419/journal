class ChartParamsService
  attr_reader :current_user
  attr_accessor :params

  def initialize(current_user, params = nil)
    @current_user = current_user
    @params = params
  end

  def datetime_params
    if (start = params["start_date"]) && (finish = params["end_date"]) && !start.strip.empty? && !finish.strip.empty?
      start_date = Time.strptime(start, "%m/%d/%Y")
      end_date =  Time.strptime(finish, "%m/%d/%Y")
    else
      end_date =  current_user.last_entry_date || Time.now
      start_date = end_date - 1.month
    end
    {start: start_date, end: end_date}
  end

  def comparison_graph?
                   !!params["emotions"] &&
                    interval_params > 0 &&
                 !emotion_params.empty? && current_user.has_journal_entries?
  end

  def emotion_params
    params["emotions"].to_a.map do |emotion, value|
      if value.to_i == 1
        current_user.active_emotion_prototypes.find{|emp| emp.name == emotion}
      end
    end.compact
  end

  def interval_params
    (params["emotions"] && params["emotions"]["days"]).to_i
  end
end
