class DashboardsController < ApplicationController

  def show
    render layout: 'wide',  :locals => {:background => "home"}
  end

end
