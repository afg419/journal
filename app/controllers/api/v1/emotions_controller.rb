class Api::V1::EmotionsController < ApplicationController
  def create
    if default_emotion = User.basic_emotion_prototypes.find_by(name: params["name"])
      current_user.emotion_prototypes += [default_emotion]
      current_user.save
      render json: {reply: "created", color: default_emotion.color, description: default_emotion.description}
    else
      emotion = current_user.emotion_prototypes.create(name: params["name"],
                                       description: params["description"],
                                             color: "rgb(200,200,200)")
                                             binding.pry
       if !emotion.id.nil?
         render json: {reply: "created", color: "rgb(200,200,200)", description: params["description"]}
       else
         render json: {reply: emotion.errors.full_messages}
       end
    end
  end

  def destroy
    name = params["id"]
    emp = current_user.emotion_prototypes.find_by(name: name)
    if emp
      current_user.emotion_prototypes -= [emp]
      current_user.save
      render json: {reply: "removed"}
    else
      render json: {reply: "You didn't have that emotion listed..."}
    end
  end
end
