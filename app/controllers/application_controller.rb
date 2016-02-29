require 'google/apis/drive_v2'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :google_service, :user_info

  def auth
    @ac ||= Auth.new( {"access_token" => access_token} )
  end

  def google_service
    @gs ||= GoogleService.new( auth, {"user_info" => user_info} )
  end

  def user_user?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_or_create_by_auth(google_service.user_info)
  end

private

  def access_token
    session[:access_token]
  end

  def user_info
    session[:user_info]
  end

  def code
    params[:code]
  end
end
