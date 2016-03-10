class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    cs = ChartService.new(current_user)
    if current_user.journal_entries?
      cs.get_emotion_data_from_user(cps.datetime_params[0], cps.datetime_params[1])
    end
    @chart = cs.render_dashboard_plot

    if cps.comparison_graph?
      ccs = ComparisonChartService.new(current_user,
                                        params["emotions"]["days"].to_i,
                                        cps.emotion_params
                                      )
      @chart2 = ccs.populate_current_chart.render_dashboard_plot
      @chart3 = ccs.populate_target_chart.render_dashboard_plot
    elsif params["emotions"]["days"].to_i < 2
      flash[:error] = "Sorry, range cannot be less than two days!"
    end
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  private

  def cps
    @cps ||= ChartParamsService.new(current_user, params)
  end
end
