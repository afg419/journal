require 'rails_helper'

RSpec.feature "Browse Entries Spec", type: :feature do
  before(:each) do
    seed_emotions_user
    @user = mock_login
    create_journal_post([7,3,5], "test1")
    create_journal_post([2,4,8], "test2")
  end

  scenario "A logged in user can get to new entry page" do
    VCR.use_cassette 'new entry' do
      visit dashboard_path
      within('.logged-in-nav') do
        click_on "Browse Journal"
      end
      expect(current_path).to eq journal_entries_path
      expect(page).to have_content "test1"
      expect(page).to have_content "test2"
    end
  end
end
