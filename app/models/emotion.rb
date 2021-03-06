class Emotion < ActiveRecord::Base
  belongs_to :journal_entry
  belongs_to :emotion_prototype

  def name
    emotion_prototype.name
  end

  def color
    emotion_prototype.color
  end

  def description
    emotion_prototype.description
  end

  def self.scores_to_hash
    all.reduce({}) do |acc, emotion|
      acc.merge({emotion.name => emotion.score}){|k, v1, v2| v1.to_i + v2.to_i}
    end
  end
end
