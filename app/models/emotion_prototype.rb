class EmotionPrototype < ActiveRecord::Base
  has_many :user_emotion_prototypes
  has_many :users, through: :user_emotion_prototypes
end
