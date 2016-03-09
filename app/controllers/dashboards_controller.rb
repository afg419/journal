class DashboardsController < ApplicationController
  include ChartParamsService

  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    cs = ChartService.new(current_user)
    if current_user.journal_entries?
      cs.get_emotion_data_from_user(datetime_params[0], datetime_params[1])
    end
    binding.pry
    @chart = cs.render_dashboard_plot

    if comparison_graph?
      cs2 = ChartService.new(current_user, {title: "#{emotion_names}",
      y_title: "",
      x_min: time_interval[:start],
      x_max: time_interval[:end]})

      cs2.get_emotion_data_from_user_for(emotion_params,
                                        interval_params[0],
                                        interval_params[1])

      sr = SelfReflection.new(current_user)
      interval = params["emotions"]["days"].to_i
      emotion_prototype = emotion_params.first
      comparisons = sr.distances_between_current_interval_and_past_intervals(emotion_prototype, interval).sort
      # comparisons = sr.distances_between_journal_and_journal_span(emotion_prototype, interval.day)
      comparisons << [0,0]
      start, fin = comparisons.first[1] - 1.day, comparisons.first[1] + interval.day + 1.day

        cs3 = ChartService.new(current_user, {title: "Time similar to current #{emotion_prototype.name}",
        y_title: "",
        x_min: start.to_i * 1000,
        x_max: fin.to_i * 1000})

      cs3.get_emotion_data_from_user_for(emotion_params,
                                        start,
                                        fin)

      @chart3 = cs3.render_dashboard_plot
      @chart2 = cs2.render_dashboard_plot
    end

    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def comparison_graph?
    !!params["emotions"] && !!params["emotions"]["days"] && !emotion_params.empty? && current_user.has_journal_entries?
  end
end
