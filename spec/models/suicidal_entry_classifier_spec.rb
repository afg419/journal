require 'rails_helper'

RSpec.describe SuicidalEntryClassifier, type: :model do
  it "initializes with data and classifiers" do
    sec = SuicidalEntryClassifier.new(mock_classifier_params)
    expect(sec.entry_data).to eq mock_classifier_params
    expect(sec.sentiment_analyzer.class).to eq Sentimental
    expect(sec.bayes_classifier.class).to eq BayesSuicideClassifier
  end

  it "uses bayes to help classify" do
    TrainingPost.create(entry: "good", classification: "ok")
    TrainingPost.create(entry: "evil", classification: "troubled")

    sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "evil"))
    expect(sec.troubled_classification?)

    sec2 = SuicidalEntryClassifier.new(mock_classifier_params("body" => "good"))
    expect(sec2.troubled_classification?).to eq false
  end

  pending "uses sentimental analysis to help classify" do
    sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I hate life"))
    expect(sec.troubled_sentiment?)

    sec2 = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I love life"))
    expect(sec2.troubled_sentiment?).to eq false
  end

  it "uses past entries to help classify in the negative" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    week_prior = Time.zone.parse('2007-02-3 15:30:45')

    seed_emotions_user_expanded_defaults
    create_journal_post([1,2,3,4,5,6],"Entry1 In week", now)
    create_journal_post([3,5,8,5,5,5],"Entry2 In week", week_prior)
    sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I hate life"))

    expect(sec.troubled_past_week?).to eq false
  end

  it "uses past entries to help classify in the positive" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    week_prior = Time.zone.parse('2007-02-3 15:30:45')

    seed_emotions_user_expanded_defaults
    #scores given [happy, sad, angry, anxious, content, focused]
    create_journal_post([1,7,6,2,1,5],"Entry1 In week", now)
    create_journal_post([2,8,8,4,0,3],"Entry2 In week", week_prior)
    sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I hate life"))

    expect(sec.troubled_past_week?).to eq true
  end

  it "classifies in the positive" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    week_prior = Time.zone.parse('2007-02-3 15:30:45')

    seed_emotions_user_expanded_defaults
    create_journal_post([1,7,6,2,1,5],"Entry1 In week", now)
    create_journal_post([2,8,8,4,0,3],"Entry2 In week", week_prior)

    BayesSuicideClassifier.new.reset_classifier
    TrainingPost.create(entry: "good", classification: "ok")
    TrainingPost.create(entry: "hate life", classification: "troubled")

    sec = SuicidalEntryClassifier.new(mock_classifier_params("body" => "I hate life"))
    expect(sec.troubled?).to eq true
  end

end
