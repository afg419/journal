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
    @chart = cs.render_dashboard_plot
    if comparison_graph?
      ccs = ComparisonChartService.new(current_user,
                                        params["emotions"]["days"].to_i,
                                        emotion_params
                                      )
      @chart2 = ccs.populate_current_chart.render_dashboard_plot
      @chart3 = ccs.populate_target_chart.render_dashboard_plot
    end
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def comparison_graph?
    !!params["emotions"] && params["emotions"]["days"].to_i > 0 && !emotion_params.empty? && current_user.has_journal_entries?
  end
end
