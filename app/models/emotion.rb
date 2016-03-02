class Emotion < ActiveRecord::Base
  belongs_to :journal_entry
  belongs_to :emotion_prototype

  def name
    emotion_prototype.name
  end
end
