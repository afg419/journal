require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'


class Auth
  attr_reader :client

  #three options: takes in {code => code}, or {access_token => access_token}
  def initialize(opts)
    @client = set_auth_client(opts)
    set_access_token if client.code
  end

  def set_auth_client(opts)
    client_secrets = Google::APIClient::ClientSecrets.load 'google/api_client/client_secrets.json'
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive',
      :redirect_uri => 'http://localhost:3000/google_api/auth'
    )
    auth_client.code, auth_client.access_token = opts["code"], opts["access_token"]
    auth_client
  end

  def set_access_token
    client.fetch_access_token!
  end
end
