class User < ActiveRecord::Base
  has_many :journal_entries
  has_many :user_emotion_prototypes
  has_many :emotion_prototypes, through: :user_emotion_prototypes

  def self.find_or_create_by_auth(opts, basic_emotion_prototypes = nil)
    user = User.find_or_create_by(email: opts["email"])
    user.name = opts["name"] if opts["name"]
    user.permission_id = opts["permission_id"] if opts["permission_id"]
    user.emotion_prototypes ||= basic_emotion_prototypes if basic_emotion_prototypes
    user.save
    user
  end
end
