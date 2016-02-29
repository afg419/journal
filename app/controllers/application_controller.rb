require 'google/apis/drive_v2'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :auth_client, :access_token, :drive_service, :current_user

  def auth_client
    @auth_client ||= set_auth_client
  end

  def access_token
    @session ||= session[:access_token]
  end

  def drive_service
    @drive ||= Google::Apis::DriveV2::DriveService.new
    @drive.authorization = auth_client
    @drive
  end

  def current_user
    @current_user ||= User.find_or_create_by_auth(session[:user_info])
  end

  def set_auth_client
    client_secrets = Google::APIClient::ClientSecrets.load 'google/api_client/client_secrets.json'
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive',
      :redirect_uri => 'http://localhost:3000/google_api/auth'
    )
    @auth_client.access_token = access_token
    @auth_client
  end
end
