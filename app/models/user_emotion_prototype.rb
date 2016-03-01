class UserEmotionPrototype < ActiveRecord::Base
  belongs_to :user
  belongs_to :emotion_prototype
end
