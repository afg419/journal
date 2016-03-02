class Api::V1::JournalEntriesController < ApplicationController

  def create
    user_id = current_user.id
    if journal_params["user_id"].to_i == current_user.id
      save = SaveToDriveService.new(google_service, user_id)
      reply = save.post_file_to_drive(params[:tag], params[:body])
      @entry = JournalEntry.create(file_id: reply.id)
      process_emotion_params
      render json: {created: "success"}
    else
      render json: {created: "error"}
    end
  end

private

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
