class DashboardsController < ApplicationController

  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

end
