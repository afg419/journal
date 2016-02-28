class SessionsController < ApplicationController

  def new
    binding.pry
    auth_uri = auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  def destroy
    session.clear
    redirect_to dashboard_path
  end

  def create
    auth_client.code = params["code"]
    auth_client.fetch_access_token!
    session[:access_token] = auth_client.access_token
    redirect_to dashboard_path
  end

end
