require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class JournalEntriesController < ApplicationController
  def new
    @entry = JournalEntry.new(user: current_user)
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def create
    binding.pry
    user_id = current_user.id
    if journal_params["user_id"].to_i == current_user.id
      new_entry = google_service.create_file(params[:tag])
      `touch entry#{user_id}.txt`
      `echo "#{params[:body]}" >> entry#{user_id}.txt`
      reply = google_service.drive.insert_file(new_entry,
        upload_source: "entry#{user_id}.txt",
        content_type: 'text/plain')
      `rm entry#{user_id}.txt`
      @entry = current_user.journal_entries.create(file_id: reply.id)
      process_emotion_params
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

  def process_emotion_params
    journal_params.except("user_id").each do |emotion, score|
      proto = current_user.emotion_prototypes.find_by(name: emotion)
      @entry.emotions.create(emotion_prototype: proto, score: score)
    end
  end
end
