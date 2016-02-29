class GoogleService
  attr_reader :auth_client, :drive, :user_info, :access_token

  def initialize(opts)
    @code = opts["code"]
    @access_token = opts["access_token"]
    @user_info = opts["user_info"]
    set_auth_client
  end

  def relog_in
    set_client_access_token
    set_drive
    set_user_info
  end

  def set_auth_client
    client_secrets = Google::APIClient::ClientSecrets.load 'google/api_client/client_secrets.json'
    client = client_secrets.to_authorization
    client.update!(
      :scope => 'https://www.googleapis.com/auth/drive',
      :redirect_uri => 'http://localhost:3000/google_api/auth'
    )
    @auth_client = client
  end

  def set_client_access_token
    if access_token
      auth_client.access_token = access_token
    elsif @code
      auth_client.code = @code
      auth_client.fetch_access_token!
    end
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
