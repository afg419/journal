require 'google/api_client/client_secrets'

class SessionsController < ApplicationController
  def new
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
    session[:user_info] = user_params(drive_service.get_about.user)
    binding.pry
    redirect_to dashboard_path
  end

private

  def user_params(user)
    {
               name: user.display_name,
              email: user.email_address,
      permission_id: user.permission_id
    }
  end
end
