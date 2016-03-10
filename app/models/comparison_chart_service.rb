class ComparisonChartService
  attr_reader :user, :interval, :emotion_prototypes

  def initialize(user, interval, emotion_prototypes)
    @user = user
    @interval = interval
    @emotion_prototypes = emotion_prototypes
  end

  def current_chart
    ChartService.new(user, {title: "#{emotion_names}",
                          y_title: "",
                            x_min: current_time_interval_js[:start],
                            x_max: current_time_interval_js[:end]})
  end

  def populate_current_chart
    current_chart.get_emotion_data_from_user_for(
                                       emotion_prototypes,
                                       current_time_interval[:start] - 1.day,
                                       current_time_interval[:end] + 1.day
                                                )
  end

  def current_time_interval_js
    current_time_interval.map do |k,v|
      [k, v.to_i * 1000]
    end.to_h
  end

  def current_time_interval
    end_time = user.last_entry_date
    start_time = end_time - interval.days
    {start: start_time, end: end_time}
  end

  def target_chart(start, fin)
    ChartService.new(user, {title: "Time similar to current",
                          y_title: "",
                            x_min: start.to_i * 1000,
                            x_max: fin.to_i * 1000})
  end

  def similar_to_current_interval(emotion_prototype)
    sr = SelfReflection.new(user, interval, emotion_prototype)
    comp = sr.distances_between_current_interval_and_past_intervals << [1000,0]
    comp.min_by{|x| x[0]}
  end

  def populate_target_chart
    emotion_prototype = emotion_prototypes.first
    sim = similar_to_current_interval(emotion_prototype)
    start, fin = sim[1] - 1.day, sim[1] + interval.day + 1.day
    target_chart(start, fin).get_emotion_data_from_user_for(
                                                             [emotion_prototype],
                                                             start,
                                                             fin
                                                            )
  end

  def emotion_names
    emotion_prototypes.map{|emp| emp.name}.join(", ")
  end
end
