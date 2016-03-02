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
    @entry = JournalEntry.find(params[:id])
    file_id = @entry.file_id
    user_id = current_user.id
    file = "#{user_id}:#{file_id}.txt"
    google_service.drive.get_file(file_id, download_dest: file)
    @file = File.open(file, 'r')
    File.delete(file)
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end
end
