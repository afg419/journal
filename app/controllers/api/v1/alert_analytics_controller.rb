class Api::V1::AlertAnalyticsController < ApplicationController

  def show
    sc = SuicidalEntryClassifier.new(classifier_params)
    reply = sc.troubled?
    if reply
      current_user.app_messages.create(message: AppMessage.help_message,
                                       status: 1,
                                       links: AppMessage.help_links)
    end
    render json: {reply: reply}
  end

private

  def classifier_params
    params.permit!
    params.except("controller","action")
  end
end
