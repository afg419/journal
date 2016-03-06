require 'google/api_client/client_secrets'

class SessionsController < ApplicationController
  def new
    auth_uri = google_service.auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def create
    auth = Auth.new( {"code" => code} )
    session[:access_token] = auth.client.access_token
    service = GoogleService.new(auth, {"access_token" => access_token})
    session[:user_info] = service.user_info
    current_user.app_messages.set_all_inactive if current_user
    redirect_to dashboard_path
  end
end
