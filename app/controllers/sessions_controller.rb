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
    create_journal_folder_if_none
    redirect_to dashboard_path
  end

private

  def create_journal_folder_if_none
    if no_folder_id || no_folder_matching_folder_id
      user, id = current_user, current_user.id
      folder_maker = SaveToDriveService.new(@service, id)
      reply = folder_maker.create_journal_folder_on_drive
      user.folder_id = reply.id
      user.save
    end
  end

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

  def no_folder_id
    current_user.folder_id == "No Folder"
  end

  def no_folder_matching_folder_id
    folders = @service.drive.list_files(q: "title contains 'reflection-journal'").items
    folder_id = current_user.folder_id
    !folders.any?{|x| x.id == folder_id}
  end
end
