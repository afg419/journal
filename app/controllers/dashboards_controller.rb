class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    cs = ChartService.new(current_user)
    cs.get_emotion_data_from_user
    @chart = cs.render_dashboard_plot
    binding.pry
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end
end
