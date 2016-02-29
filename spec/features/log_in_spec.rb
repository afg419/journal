require 'rails_helper'

RSpec.feature "LogInSpec", type: :feature do
  scenario "A user can log in through drive" do
    VCR.use_cassette 'login' do
      mock_login
      visit root_path
      expect(page).to have_content("afg419@gmail.com")
    end
  end

  # scenario "A user can be oauthed with drive" do
  #   VCR.use_cassette 'oauth' do
  #     mock_oauth
  #     visit root_path
  #     click_on "Login with Google Drive"
  #     expect(page).to have_content("afg419@gmail.com")
  #   end
  # end
end
