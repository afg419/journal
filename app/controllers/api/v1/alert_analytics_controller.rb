class Api::V1::AlertAnalyticsController < ApplicationController

  def show
    sc = SuicidalEntryClassifier.new(classifier_params)
    reply = sc.troubled?
    render json: {reply: true}
  end

private

  def classifier_params
    params.permit!
    params.except("controller","action")
  end
end
