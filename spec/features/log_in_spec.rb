require 'rails_helper'

RSpec.feature "LogInSpec", type: :feature do

  before(:each) do
    seed_emotions_user
  end

  scenario "A logged in user can see email" do
    VCR.use_cassette 'login' do
      mock_login
      visit dashboard_path
      expect(page).to have_content("Logout")
    end
  end

  scenario "A non-logged in user can see login button" do
    VCR.use_cassette 'not-logged-in' do
      visit root_path
      expect(page).to have_content("Login with Google Drive")
    end
  end

  scenario "A non-logged in user redirected to root" do
    VCR.use_cassette 'not-logged-in' do
      visit dashboard_path
      expect(page).to have_content("Login with Google Drive")
    end
  end

  scenario "A logged in user redirected to dashboard_path" do
    VCR.use_cassette 'login' do
      mock_login
      visit root_path
      expect(page).to have_content("Logout")
    end
  end
end
