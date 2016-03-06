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

    expect(@user.active_emotion_prototypes.count).to eq 6
    expect(@user.inactive_emotion_prototypes.count).to eq 0

    @user.set_emotion_prototype("inactive", "sad")

    expect(@user.active_emotion_prototypes.count).to eq 5
    expect(@user.inactive_emotion_prototypes.count).to eq 1

    sad = @emotion_prototypes[1]
    post :create, mock_emotion_params({"name" => "sad"})

    expect(@user.active_emotion_prototypes.count).to eq 6
    expect(@user.inactive_emotion_prototypes.count).to eq 0

    reply = "{\"reply\":\"created\",\"color\":\"#{sad.color}\",\"description\":\" \"}"

    expect(response.body).to eq reply
    expect(response.status).to eq 200
  end

  it "it refuses to render new emotion without name" do
    mock_login

    expect(@user.active_emotion_prototypes.count).to eq 6
    expect(@user.inactive_emotion_prototypes.count).to eq 0

    post :create, mock_emotion_params({"name" => ""})

    expect(@user.active_emotion_prototypes.count).to eq 6
    expect(@user.inactive_emotion_prototypes.count).to eq 0

    reply = "{\"reply\":[\"Name can't be blank\"]}"

    expect(response.body).to eq reply
    expect(response.status).to eq 200
  end
end
