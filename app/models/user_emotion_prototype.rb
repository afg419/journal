class UserEmotionPrototype < ActiveRecord::Base
  belongs_to :user
  belongs_to :emotion_prototype

  # validate :unique_name_per_user
  #
  # def unique_name_per_user
  #   users_emotion_names = UserEmotionPrototype.where(id: user.id).all.map{|x| x.emotion_prototype.name}
  #   if users_emotion_names.include?(emotion_prototype.name)
  #     errors.add(:name, "already taken!")
  #   end
  # end
end
