class EmotionPrototype < ActiveRecord::Base
  validates :name, presence: true
  validates_associated :user_emotion_prototypes

  has_many :user_emotion_prototypes
  has_many :users, through: :user_emotion_prototypes
  has_many :emotions
end
