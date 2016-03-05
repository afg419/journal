class Emotion < ActiveRecord::Base
  belongs_to :journal_entry
  belongs_to :emotion_prototype

  def name
    emotion_prototype.name
  end

  def self.belongs_to(user)
    joins(:journal_entry).where(journal_entry: {user_id: 2})
  end

  def self.scores_to_hash
    all.reduce({}) do |acc, emotion|
      acc.merge({emotion.emotion_prototype.name => emotion.score})
    end
  end
end
