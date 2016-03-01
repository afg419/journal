class Emotion < ActiveRecord::Base
  belongs_to :journal_entry
  belongs_to :emotion_prototype
end
