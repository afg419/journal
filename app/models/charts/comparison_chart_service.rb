class ComparisonChartService
  attr_reader :user, :interval, :emotion_prototypes, :current_chart_renderer,
              :similar_chart_renderer

  def initialize(user, interval, emotion_prototypes)
    @user = user
    @interval = interval
    @emotion_prototypes = emotion_prototypes

    if render_comparison_graph?
      @current_chart_renderer = chart_renderer_for(current_dates)
      @similar_chart_renderer = chart_renderer_for(similar_dates)
    end
  end

  def render_current_and_similar_charts
    if render_comparison_graph?
      renderers = [current_chart_renderer, similar_chart_renderer]
      renderers.map(&:render_dashboard_plot)
    else
      [nil, nil]
    end
  end

  def graph_fail_reasons
    {
      true => "",
      (interval <= 0) => "Please select a positive number of days back to compare.",
      (emotion_prototypes.empty?) => "Please select an emotion or emotions to compare.",
      (!user.has_sufficient_journal_entries?(interval)) => "Sorry, the interval you've selected exceeds the range of times of your journal entry submissions.  Please try a smaller interval."
    }[true]
  end

  def render_comparison_graph?
    interval > 0 && !emotion_prototypes.empty? && user.has_sufficient_journal_entries?(interval)
  end

private

  def chart_renderer_for(dates)
    cdp = ChartDataPrepService.new(user, emotion_prototypes, dates)
    ChartRenderer.new(prepped_data(cdp), dates)
  end

  def current_dates
    end_time = user.last_entry_date
    start_time = end_time - interval.days
    {start: start_time, end: end_time}
  end

  def similar_dates
    start_time = start_of_similar_interval
    end_time = start_time + interval.days
    {start: start_time, end: end_time}
  end

  def prepped_data(data_prep)
    data_prep.emotion_data
  end

# computing the beast

  def similarity_to_current_interval(emotion_prototype)
    sr = SelfReflection.new(user, interval, emotion_prototype)
    sr.distances_between_current_interval_and_past_intervals << [1000,Time.now]
  end

  def start_of_similar_interval
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

    sim_almost[0]
  end
end
