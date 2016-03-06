class User < ActiveRecord::Base
  has_many :journal_entries
  has_many :user_emotion_prototypes
  has_many :emotion_prototypes, through: :user_emotion_prototypes

  def self.find_or_create_by_auth(opts)
    user = User.find_or_create_by(email: opts["email"])
    user.name = opts["name"] if opts["name"]
    user.permission_id = opts["permission_id"] if opts["permission_id"]
    user.emotion_prototypes = User.basic_emotion_prototypes if user.emotion_prototypes.empty?
    user.save
    user
  end

  def self.basic_emotion_prototypes
    User.find_by(email: "basic_emotion_prototypes").emotion_prototypes
  end

  def active_emotion_prototypes
    user_emotion_prototypes.where(status: "active").map{|x| x.emotion_prototype}
  end

  def scores_for(emotion_prototype)
    journal_entries.map do |je|
      {
        created_at: je.created_at,
        score: je.emotions.find_by(emotion_prototype: emotion_prototype).score,
        tag: je.tag
      }
    end
  end

  def chart_emotion_data
    {id => emotion_prototypes.all.reduce({}) do |acc, emotion_prototype|
      acc.merge({emotion_prototype.name => {color: emotion_prototype.color, scores: scores_for(emotion_prototype)}})
    end}
  end
end
