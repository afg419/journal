require 'google/api_client/client_secrets'

class SessionsController < ApplicationController
  def new
    auth_uri = google_service.auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  def destroy
    session.clear
    redirect_to dashboard_path
  end

  def create
    auth = Auth.new(params)
    session[:access_token] = auth.client.access_token
    service = GoogleService.new(auth, session)
    session[:user_info] = service.user_info
    redirect_to dashboard_path
  end
end
