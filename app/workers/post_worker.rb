class PostWorker
  include Sidekiq::Worker

  def perform(access_token, user_info, params)
    puts "Performing background worker"
    puts params

    user_id = current_user(user_info, access_token).id
    puts user_id

    save = SaveToDriveService.new(google_service(user_info, access_token), user_id)
    reply = save.post_file_to_drive(params[:tag], params[:body])
    puts reply
    puts reply.id
    entry = JournalEntry.create(tag: params[:tag],
                            file_id: reply.id,
                            user_id: user_id)
    process_emotion_params(params, entry, user_info, access_token)
  end

  def auth(access_token)
    Auth.new( {"access_token" => access_token} )
  end

  def google_service(user_info, access_token)
    GoogleService.new( auth(access_token), {"user_info" => user_info} )
  end

  def current_user(user_info, access_token)
    User.includes(:emotion_prototypes).find_or_create_by_auth(google_service(user_info, access_token).user_info) if access_token
  end

  def process_emotion_params(params, entry, user_info, access_token)
    params.except("user_id", "tag", "body","controller","action").each do |emotion, score|
      proto = current_user(user_info, access_token).emotion_prototypes.find_by(name: emotion)
      entry.emotions.create(emotion_prototype: proto, score: score)
    end
  end
end

#call PostWorker.perform_asynch()
