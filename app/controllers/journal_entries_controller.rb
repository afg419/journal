require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class JournalEntriesController < ApplicationController
  def index
    @entries = current_user.journal_entries
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def new
    @entry = JournalEntry.new(user: current_user)
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def show
    file_name = file_name(params[:id])
    file_contents = file_from_drive(file_name)
    @journal_entry = {entry: @entry, body: file_contents, :empty? => file_contents.empty?}
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def file_name(id)
    @entry = JournalEntry.find(id)
    file_name = "#{current_user.id}:#{@entry.file_id}.txt"
  end

  def file_from_drive(file_name)
    buffer = StringIO.new
    google_service.drive.get_file(@entry.file_id, download_dest: buffer)
    buffer.rewind
    buffer.read
  end
end

# # # Download a file's content
# # #
# # # @param [Google::Apis::DriveV2::DriveService] client
# # #   Authorized client instance
# # # @param [Google::Apis::DriveV2::File]
# # #   Drive File instance
# # # @return
# # #   File's content if successful, nil otherwise
# def download_file(client, file)
#   buffer = StringIO.new
#   begin
#     client.get_file(file.id, download_dest: buffer)
#     return buffer.to_s
#   rescue Google::Apis::Error => e
#     puts "Unable to download file: #{e.message}"
#     return nil
#   end
# end
