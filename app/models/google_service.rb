class GoogleService
  attr_reader :auth_client, :drive, :user_info, :access_token

  def initialize(auth, opts)
    @auth_client = auth.client
    @user_info = opts["user_info"]
    set_drive if auth_client.access_token
    set_user_info if drive
  end

  def set_drive
    drive = Google::Apis::DriveV2::DriveService.new
    drive.authorization = auth_client
    @drive = drive
  end

  def set_user_info
    @user_info ||= user_params(drive.get_about.user)
  end

  def user_params(user)
    {
               name: user.display_name,
              email: user.email_address,
      permission_id: user.permission_id
    }
  end
end
