require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  it "redirects to google drive login with new" do
    get :new
    expect(response.status).to eq 302
  end

  it "logs a user in" do
    VCR.use_cassette 'logging-in' do
      post :create
      ApplicationController.any_instance.stubs(:access_token).returns("ya29.lwI69xOk_BgRvmV-xPKLiQllNHkO26TGAKXZJgWKRQ4F0hoA1Pjb9vH3SIZWfyBSZ0U")
      expect(response.status).to eq 302
      assert_redirected_to dashboard_path
    end
  end

  it "logs out a user" do
    delete :destroy
    expect(response.status).to eq 302
    assert_redirected_to root_path
  end
end
