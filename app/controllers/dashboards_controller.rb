class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    @chart = cs.populate_overall_chart(dates_for_overall_chart)
    @chart2, @chart3 = ccs.populate_comparison_charts
    if @chart3.nil? && params[:emotions]
      flash.now[:comparison_error] = ccs.graph_fail_reasons
    end
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def cps
    @cps ||= ChartParamsService.new(current_user, params)
  end

  def cs
    @cs ||= ChartService.new(current_user, dates_for_overall_chart)
  end

  def ccs
    @ccs ||= ComparisonChartService.new(current_user,
                                        cps.interval_params,
                                        cps.emotion_params)
  end

  def dates_for_overall_chart
    cps.datetime_params
  end
end
