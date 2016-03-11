require 'google/apis/drive_v2'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :google_service, :user_info
  before_action :authorize!

  def auth
    @ac ||= Auth.new( {"access_token" => access_token} )
  end

  def google_service
    @gs ||= GoogleService.new( auth, {"user_info" => user_info} )
  end

  def current_user
    @current_user ||= User.includes(:emotion_prototypes).find_or_create_by_auth(google_service.user_info) if access_token
  end

  def authorize!
    @ps = PermissionService.new(current_user)
    permission = @ps.allow?(params[:controller], params[:action])
    unless permission[0]
      redirect_to permission[1]
    end
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
