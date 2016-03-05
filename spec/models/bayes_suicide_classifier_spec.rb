require 'rails_helper'

RSpec.describe BayesSuicideClassifier, type: :model do
  it "trains on posts" do
    TrainingPost.create(entry: "good", classification: "ok")
    TrainingPost.create(entry: "evil", classification: "troubled")

    b = BayesSuicideClassifier.new
    b.train_on_training_posts

    expect(b.classifier.classify "good").to eq "Ok"
    expect(b.classifier.classify "evil").to eq "Troubled"
    expect(b.classifier.classify "duck").to eq "Ok"
  end
end
