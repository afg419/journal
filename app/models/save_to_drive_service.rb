class SaveToDriveService
  attr_reader :file_name, :google_service

  def initialize(google_service, user_id)
    @file_name = "entry#{user_id}.txt"
    @google_service = google_service
  end

  def create_file(tag)
    google_service.create_file(tag)
  end

  def save_file_locally(body)
    File.write(file_name, body)
  end

  def send_to_drive(file)
    google_service.drive.insert_file(
        file,
        upload_source: file_name,
        content_type: 'text/plain'
      )
  end

  def delete_local_file
    File.delete(file_name)
  end

  def post_file_to_drive(tag, body)
    file = create_file(tag)
    save_file_locally(body)
    reply = send_to_drive(file)
    delete_local_file
    reply
  end
end
