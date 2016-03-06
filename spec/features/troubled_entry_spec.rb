# require 'rails_helper'
#
# RSpec.feature "Troubled entry spec", type: :feature do
#   before(:each) do
#     seed_emotions_user_expanded_defaults
#   end
#
#   scenario "A user with troubled past posts and troubled current posts gets advice", js: true do
#     VCR.use_cassette 'creates and views troubled entry' do
#       now = Time.now
#       week_prior = Time.now - 6.day
#
#       seed_emotions_user_expanded_defaults
#       create_journal_post([1,7,6,2,1,5],"Entry1 In week", now)
#       create_journal_post([2,8,8,4,0,3],"Entry2 In week", week_prior)
#
#       BayesSuicideClassifier.new.reset_classifier
#       TrainingPost.create(entry: "good", classification: "ok")
#       TrainingPost.create(entry: "hate life", classification: "troubled")
#
#       sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I hate life"))
#       expect(sec.troubled?).to eq true
#
#       mock_login
#       visit new_journal_entry_path
#
#       fill_in("journal_entry[tag]", with: "Title1")
#       fill_in("journal_entry[body]", with: "I hate life")
#
#       page.find(".submit-entry").click
#       sleep(3)
#       binding.pry
#     end
#   end
# end
