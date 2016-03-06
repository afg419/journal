class EmotionPrototype < ActiveRecord::Base
  validates :name, presence: true
  validates_associated :user_emotion_prototypes

  has_many :user_emotion_prototypes
  has_many :users, through: :user_emotion_prototypes
  has_many :emotions

  def user_data(user)
    users.find_by(id: user_id)
  end
end
