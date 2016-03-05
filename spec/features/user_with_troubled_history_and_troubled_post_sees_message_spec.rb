require 'rails_helper'

RSpec.feature "Troubled post spec", type: :feature do
  scenario "A user with a troubled posting history and submitting a troubled post sees message", js: true do
    VCR.use_cassette 'posts-troubling-entry' do
      now = Time.now
      week_prior = Time.now - 6.day

      BayesSuicideClassifier.new.reset_classifier
      TrainingPost.create(entry: "good", classification: "ok")
      TrainingPost.create(entry: "hate life", classification: "troubled")
      seed_emotions_user_expanded_defaults

      mock_login

      create_journal_post([1,7,6,2,1,5],"Entry1 In week", now, @user)
      create_journal_post([2,8,8,4,0,3],"Entry2 In week", week_prior, @user)

      visit new_journal_entry_path

      fill_in("journal_entry[tag]", with: "Title1")
      fill_in("journal_entry[body]", with: "I hate life")

      page.find(".submit-entry").click
      click_on "Home Page"

      # expect(page).to have_content(AppMessage.national_suicide_prevention_hotline)
    end
  end
end
