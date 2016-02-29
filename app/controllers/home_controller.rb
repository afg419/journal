class HomeController < ApplicationController

  def home
    render layout: 'wide',  :locals => {:background => "home"}
  end

end
