class Api::V1::AlertAnalyticsController < ApplicationController

  def show
    sc = SuicidalEntryClassifier.new(classifier_params)
    reply = sc.troubled?
    if reply
      current_user.app_messages.create(message: AppMessage.google_therapy_search, status: 1)
    end
    render json: {reply: reply}
  end

private

  def classifier_params
    params.permit!
    params.except("controller","action")
  end
end
