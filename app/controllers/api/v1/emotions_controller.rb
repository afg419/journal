class Api::V1::EmotionsController < ApplicationController
  def create
    if default_emotion = current_user.inactive_emotion_prototypes.find{|emp| emp.name == params["name"]}
      current_user.set_emotion_prototype("active", params["name"])
      render json: {reply: "created", color: default_emotion.color, description: default_emotion.description}
    else
      emotion = current_user.emotion_prototypes.create(name: params["name"],
                                       description: params["description"],
                                             color: "rgb(200,200,200)")
       if !emotion.id.nil?
         render json: {reply: "created", color: "rgb(200,200,200)", description: params["description"]}
       else
         render json: {reply: emotion.errors.full_messages}
       end
    end
  end

  def destroy
    emotion = current_user.active_emotion_prototypes.find{|emp| emp.name == params["id"]}
    if emotion
      current_user.set_emotion_prototype("inactive", emotion.name)
      render json: {reply: "removed"}
    else
      render json: {reply: "You didn't have that emotion listed..."}
    end
  end
end
