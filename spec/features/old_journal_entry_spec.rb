require 'rails_helper'

RSpec.feature "New Journal Spec", type: :feature do
  before(:each) do
    seed_emotions_user
  end

  scenario "A user with a post on drive can view it", js: true do
    VCR.use_cassette 'creates and views entry' do
      mock_login
      visit new_journal_entry_path

      fill_in("journal_entry[tag]", with: "Title1")
      fill_in("journal_entry[body]", with: "Content1")

      page.find(".submit-entry").click

      click_on "Browse Journal"
      click_on "Title1"

      entry = JournalEntry.last

      expect(current_path).to eq journal_entry_path entry
      expect(page).to have_content("Content1")
      expect("true").to eq find('#tag')['readonly']
      expect("true").to eq find('#journal_entry_body')['readonly']
    end
  end
end
