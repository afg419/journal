require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class JournalEntriesController < ApplicationController
  def new
    @entry = JournalEntry.new(user: current_user)
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def create
    user_id = current_user.id
    if journal_params["user_id"].to_i == current_user.id
      new_entry = google_service.create_file(params[:tag])
      `touch entry#{user_id}.txt`
      `echo "#{params[:body]}" >> entry#{user_id}.txt`
      reply = google_service.drive.insert_file(new_entry,
        upload_source: "entry#{user_id}.txt",
        content_type: 'text/plain')
      `rm entry#{user_id}.txt`
      @entry = JournalEntry.create(file_id: reply.id)
      render json: {created: "success"}
      # redirect_to journal_entry_path(@entry)
    else
      render json: {created: "error"}

    end
  end

  def show
    @entry = JournalEntry.find(params[:id])
  end

  private

  def insert_emotion_scores

  end

  def journal_params
    params.permit!
    params.except("controller","action","tag","body")
  end
end
