class SaveToDriveService
  attr_reader :file_name, :google_service

  def initialize(google_service, user_id)
    @file_name = "entry#{user_id}.txt"
    @google_service = google_service
  end

  def create_file(tag)
    google_service.create_file(tag)
  end

  def send_to_drive(file, buffer)
    google_service.drive.insert_file(
        file,
        upload_source: buffer,
        content_type: 'text/plain'
      )
  end

  def post_file_to_drive(tag, body)
    file = create_file(tag)
    buffer = StringIO.new(body)
    send_to_drive(file, buffer)
  end
end
