require 'rails_helper'

RSpec.feature "New Journal Spec", type: :feature do
  scenario "A logged in user can get to new entry page" do
    VCR.use_cassette 'new entry' do
      mock_login
      visit dashboard_path
      click_on "New Journal Entry"
      expect(current_path).to eq new_journal_entry_path
    end
  end

  # scenario "A logged in user can get to new entry page" do
  #   VCR.use_cassette 'new entry' do
  #     mock_login
  #     visit dashboard_path
  #     click_on "New Journal Entry"
  #     expect(current_path).to eq new_entry_path
  #   end
  # end
end
