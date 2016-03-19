class ComparisonChartService
  attr_reader :user, :interval, :emotion_prototypes

  def initialize(user, interval, emotion_prototypes)
    @user = user
    @interval = interval
    @emotion_prototypes = emotion_prototypes
  end

  def populate_comparison_charts
    if render_comparison_graph?
      current_plot = populate_current_chart.render_dashboard_plot
      target_plot = populate_target_chart.render_dashboard_plot
      [current_plot, target_plot]
    else
      [nil, nil]
    end
  end

  def populate_current_chart
    current_chart.get_emotion_data_from_user_for(
      emotion_prototypes,
      current_time_interval[:start] - 1.day,
      current_time_interval[:end] + 1.day
    )
  end

  def populate_target_chart
    similarities = emotion_prototypes.reduce([]) do |acc, emp|
      acc + similarity_to_current_interval(emp)
    end

    sims_by_time = similarities.group_by do |similarity_measure|
      similarity_measure[1]
    end.to_a

    sim_almost = sims_by_time.min_by do |time_sims|
      time_sims[1].reduce(0) do |acc, score_time|
        acc + score_time[0]
      end
    end

    sim = [sim_almost[0], sim_almost[1].reduce(0) do |acc, score_time|
      acc + score_time[0]
    end]

    start, fin = sim[0] - 1.day, sim[0] + interval.day + 1.day

    target_chart(start, fin).get_emotion_data_from_user_for(
      emotion_prototypes,
      start,
      fin
    )
  end

  def current_chart
    ChartService.new(user,
      {title: "Past #{interval} day period for: #{emotion_names}",
       y_title: "",
       x_min: current_time_interval_js[:start],
       x_max: current_time_interval_js[:end],
       size: "medium"}
    )
  end

  def target_chart(start, fin)
    ChartService.new(user,
     {title: "Most similar #{interval} day period for: #{emotion_names} ",
      y_title: "",
      x_min: start.to_i * 1000,
      x_max: fin.to_i * 1000,
      size: "medium"}
    )
  end

  def render_comparison_graph?
    interval > 0 && !emotion_prototypes.empty? && user.has_journal_entries? && user.has_sufficient_journal_entries?(interval)
  end

  def graph_fail_reasons
    {
      true => "",
      (interval <= 0) => "Please select a positive number of days back to compare.",
      (emotion_prototypes.empty?) => "Please select an emotion or emotions to compare.",
      (!user.has_sufficient_journal_entries?(interval)) => "Sorry, the interval you've selected exceeds the range of times of your journal entry submissions.  Please try a smaller interval."
    }[true]
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

  def similarity_to_current_interval(emotion_prototype)
    sr = SelfReflection.new(user, interval, emotion_prototype)
    comp = sr.distances_between_current_interval_and_past_intervals << [1000,Time.now]
  end

  def emotion_names
    emotion_prototypes.map{|emp| emp.name.capitalize}.join(", ")
  end
end
