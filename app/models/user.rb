class User < ActiveRecord::Base
  has_many :journal_entries
  has_many :user_emotion_prototypes
  has_many :emotion_prototypes, through: :user_emotion_prototypes
  has_many :app_messages

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

  def inactive_emotion_prototypes
    user_emotion_prototypes.where(status: "inactive").map{|x| x.emotion_prototype}
  end

  def set_emotion_prototype(status, name)
    emp = user_emotion_prototypes.find{|x| x.emotion_prototype.name == name}
    emp.status = status
    emp.save
  end

  def scores_for(emotion_prototype, start_time, end_time)
    entries = journal_entries.where("created_at >= :start_time AND created_at <= :end_time",
    {start_time: start_time, end_time: end_time})
    entries.map do |je|
      next unless emp = je.emotions.find_by(emotion_prototype: emotion_prototype)
      {
        created_at: je.created_at,
        score: emp.score,
        tag: je.tag
      }
    end
  end

  def first_entry_date
    journal_entries.order(:created_at).first.created_at
  end

  def last_entry_date
    journal_entries.order(:created_at).last.created_at
  end

  def chart_emotion_data(start_time, end_time)
    {id => emotion_prototypes.all.reduce({}) do |acc, emotion_prototype|
      acc.merge({
                  emotion_prototype.name =>
                    {
                     color: emotion_prototype.color,
                    scores: scores_for(emotion_prototype, start_time, end_time)
                    }
                  }
                )
    end}
  end

  def journal_entries?
    journal_entries.count > 0
  end

  def scores_for_with_endpoints(emotion_prototype, start_time, end_time)
  end
end
