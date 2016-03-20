
class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    @chart = overall_chart_service.render_overall_chart
    @chart2, @chart3 = comparison_chart_service.render_current_and_similar_charts
    if comparison_charts_fail?
      flash.now[:comparison_error] = comparison_chart_service.graph_fail_reasons
    end
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def overall_chart_service
    @ocs ||= OverallChartService.new(current_user, dates_for_overall_chart)
  end

  def comparison_chart_service
    @ccs ||= ComparisonChartService.new(current_user, cps.interval_params, cps.emotion_params)
  end

  def cps
    @cps ||= ChartParamsService.new(current_user, params)
  end

  def comparison_charts_fail?
    !comparison_chart_service.render_comparison_graph? && params[:emotions]
  end

  def dates_for_overall_chart
    cps.datetime_params
  end
end
