class SaveToDriveService
  attr_reader :file_name, :google_service

  def initialize(google_service, user_id)
    @file_name = "entry#{user_id}.txt"
    @google_service = google_service
  end

  def create_journal_folder
    google_service.create_file("reflection-journal")
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

  def create_journal_folder_on_drive
    folder = create_journal_folder
    folder.mime_type = "application/vnd.google-apps.folder"
    google_service.drive.insert_file(folder)
  end
end
