class User < ActiveRecord::Base
  include UserHelper
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
    emotion_prototypes.joins(:user_emotion_prototypes).where(user_emotion_prototypes: {status: "active"})
  end

  def inactive_emotion_prototypes
    emotion_prototypes.joins(:user_emotion_prototypes).where(user_emotion_prototypes: {status: "inactive"})
  end

  def set_emotion_prototype(status, name)
    emp = user_emotion_prototypes.find{|x| x.emotion_prototype.name == name}
    emp.status = status
    emp.save
  end

  def first_entry_date
    (@fed ||= journal_entries.order(:created_at).first.created_at) unless journal_entries.to_a.empty?
  end

  def last_entry_date
    (@led ||= journal_entries.order(:created_at).last.created_at) unless journal_entries.to_a.empty?
  end

  def mem_journal_entries
    @mje ||= journal_entries.includes(:emotions)
  end

  def has_journal_entries?
    !journal_entries.empty?
  end
end
