require 'rails_helper'

RSpec.feature "New Journal Spec", type: :feature do
  before(:each) do
    seed_emotions_user
  end

  scenario "A logged in user can get to new entry page" do
    VCR.use_cassette 'new entry' do
      mock_login
      visit dashboard_path
      within('.logged-in-nav') do
        click_on "New Journal Entry"
      end
      expect(current_path).to eq new_journal_entry_path
    end
  end

  scenario "A logged in user can get to new entry page", js: true do
    VCR.use_cassette 'creates entry' do
      mock_login
      visit new_journal_entry_path

      page.find(".submit-entry").click

      expect(current_path).to eq new_journal_entry_path
      expect(page).to_not have_content("Submit Entry")
      expect(page).to have_content("Your Journal Entry has been Submitted")
      expect("true").to eq find('#tag')['readonly']
      expect("true").to eq find('#journal_entry_body')['readonly']
    end
  end
end
