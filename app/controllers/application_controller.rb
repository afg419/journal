require 'google/apis/drive_v2'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :google_service

  def google_service
    @gs ||= GoogleService.new(session)
  end

  def current_user
    @current_user ||= User.find_or_create_by_auth(google_service.user_info)
  end
end
