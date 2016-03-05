require 'rails_helper'

RSpec.describe Emotion, type: :model do
  it "takes on the name of its emotion prototype" do
    happy = EmotionPrototype.create(name: "happy")
    happy_score = Emotion.create(emotion_prototype: happy, score: 5)

    expect(happy_score.name).to eq "happy"
  end

  it "'s collections can be reduced to score hashes'" do
    happy = EmotionPrototype.create(name: "happy")
    happy_score = Emotion.create(emotion_prototype: happy, score: 5)

    sad = EmotionPrototype.create(name: "sad")
    sad_score = Emotion.create(emotion_prototype: sad, score: 3)

    expect(Emotion.scores_to_hash).to eq({"happy" => 5, "sad" => 3})
  end
end
