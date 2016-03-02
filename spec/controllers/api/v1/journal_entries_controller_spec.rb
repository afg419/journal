require 'rails_helper'

RSpec.describe Api::V1::JournalEntriesController, type: :controller do
  before(:each) do
    seed_emotions_user
  end

  it "redirects to google drive login with new" do
    VCR.use_cassette 'posting-from-controller' do
      user = mock_login
      emotion_selection = { happy: 0, sad: 5, angry: 10 }
      post :create, happy: 0, sad: 5, angry: 10, user_id: user.id, tag: "Test", body: "Test2"

      expect(response.body).to eq "{\"created\":\"success\"}"
      expect(response.status).to eq 200

      entry = JournalEntry.last
      expect(entry.user_id).to eq user.id
      expect(entry.tag).to eq "Test"

      emotions = entry.emotions
      emotions.each do |emotion|
        expect(emotion_selection[emotion.name.to_sym]).to eq emotion.score
      end
    end
  end

  it "redirects to google drive login with new" do
    VCR.use_cassette 'posting-from-controller' do
      user = mock_login
      emotion_selection = { happy: 0, sad: 5, angry: 10 }
      post :create, happy: 0, sad: 5, angry: 10, user_id: user.id+1, tag: "Test", body: "Test2"

      expect(response.body).to eq "{\"created\":\"error\"}"
      expect(response.status).to eq 200

      expect(0).to eq JournalEntry.count
    end
  end

end
