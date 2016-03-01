require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class JournalEntriesController < ApplicationController
  def new
    @entry = JournalEntry.new
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def create
    user_id = current_user.id
    new_entry = google_service.create_file(journal_params[:tag])
    `touch entry#{user_id}.txt`
    `echo "#{journal_params[:body]}" >> entry#{user_id}.txt`
    reply = google_service.drive.insert_file(new_entry,
                                             upload_source: "entry#{user_id}.txt",
                                             content_type: 'text/plain')
    `rm entry#{user_id}.txt`
    @entry = JournalEntry.create(file_id: reply.id, user: current_user)
    redirect_to dashboard_path
  end

  private

  def insert_emotion_scores

  end

  def journal_params
    params.require(:journal_entry).permit(:tag, :body)
  end
end
