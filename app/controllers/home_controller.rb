class HomeController < ApplicationController

  def home
    if access_token
      redirect_to dashboard_path
    else
      render layout: 'wide',  :locals => {:background => "home"}
    end
  end

end
