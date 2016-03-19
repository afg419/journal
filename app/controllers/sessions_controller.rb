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
    access_token = initialize_authenticator_and_get_token
    initialize_google_service_and_set_user_info(access_token)
    clear_users_app_messages
    redirect_to dashboard_path
  end

private

  def clear_users_app_messages
    current_user.app_messages.set_all_inactive if current_user
  end

  def initialize_authenticator_and_get_token
    @auth = Auth.new({"code" => code})
    session[:access_token] = @auth.client.access_token
  end

  def initialize_google_service_and_set_user_info(access_token)
    @service = GoogleService.new(@auth, {"access_token" => access_token})
    session[:user_info] = @service.user_info
  end
end
