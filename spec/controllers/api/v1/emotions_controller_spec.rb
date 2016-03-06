require 'rails_helper'

RSpec.describe Api::V1::EmotionsController, type: :controller do
  before(:each) do
    seed_emotions_user_expanded_defaults
  end

  it "creates new emotion" do
    mock_login
    expect(@user.active_emotion_prototypes.count).to eq 6
    post :create, mock_emotion_params

    expect(@user.active_emotion_prototypes.count).to eq 7
    expect(@user.active_emotion_prototypes.last.name).to eq "connection"

    reply = "{\"reply\":\"created\",\"color\":\"rgb(200,200,200)\",\"description\":\"#{mock_emotion_params["description"]}\"}"

    expect(response.body).to eq reply
    expect(response.status).to eq 200
  end

  it "recovers old emotion" do
    mock_login

  end
end
