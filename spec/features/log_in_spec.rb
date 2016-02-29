require 'rails_helper'

RSpec.feature "LogInSpec", type: :feature do
  scenario "A user can log in through drive" do
    # ApplicationController.any_instance.stubs(:current_user).returns(true)
    VCR.use_cassette 'login' do
      mock_login
      visit root_path
      expect(page).to have_content("afg419@gmail.com")
    end
  end
end
