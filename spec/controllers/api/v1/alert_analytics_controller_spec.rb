require 'rails_helper'

RSpec.describe Api::V1::AlertAnalyticsController, type: :controller do
  before(:each) do
    seed_emotions_user_expanded_defaults
  end

  it "replies with troubled classification" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    week_prior = Time.zone.parse('2007-02-3 15:30:45')

    seed_emotions_user_expanded_defaults
    create_journal_post([1,7,6,2,1,5],"Entry1 In week", now)
    create_journal_post([2,8,8,4,0,3],"Entry2 In week", week_prior)

    BayesSuicideClassifier.new.reset_classifier
    TrainingPost.create(entry: "good", classification: "ok")
    TrainingPost.create(entry: "hate life", classification: "troubled")
    user = mock_login
    post :show, mock_classifier_params({"body" => "I hate life"})

    expect(@user.app_messages.current_message.message).to eq AppMessage.help_message
    expect(response.body).to eq "{\"reply\":true}"
    expect(response.status).to eq 200
  end
end
