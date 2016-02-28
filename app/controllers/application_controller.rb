class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :auth_client, :access_token

  def auth_client
    unless @auth_client
      client_secrets = Google::APIClient::ClientSecrets.load 'google/api_client/client_secrets.json'
      @auth_client = client_secrets.to_authorization
      @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive',
      :redirect_uri => 'http://localhost:3000/google_api/auth'
      )
    end
    @auth_client.access_token = access_token
    @auth_client
  end

  def access_token
    @session ||= session[:access_token]
  end

end
