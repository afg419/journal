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
    entry = JournalEntry.find(params[:id])
    file_name = "#{current_user.id}:#{entry.file_id}.txt"
    google_service.drive.get_file(entry.file_id, download_dest: file_name)
    file_contents = File.open(file_name, 'r').read
    File.delete(file_name)
    @journal_entry = {entry: entry, body: file_contents, :empty? => file_contents.empty?}
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end
end
