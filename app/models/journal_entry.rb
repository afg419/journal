class JournalEntry < ActiveRecord::Base
  belongs_to :user
  has_many :emotions

  def datetime
    "#{created_at.month}/#{created_at.day}/#{created_at.year} #{created_at.hour}h"
  end

  def self.net_data
    all.reduce({}) do |acc, je|
      acc.merge(je.emotions.scores_to_hash){|k,v1,v2| v1 + v2}
    end.merge({"total" => count})
  end

  def mem_emotions
    @mem ||= emotions.includes(:emotion_prototype)
  end

  def prior_week_entries
    JournalEntry.where("created_at >= :start_date AND created_at <= :end_date",
    {start_date: created_at-7.day, end_date: created_at})
  end

  def self.closest_entry_to(time)
    all.sort_by{|je| (je.created_at - time)**2}.first
  end

  def self.scores_for(emotion_prototype, start_time, end_time)
    entries = order(:created_at).where("created_at >= :start_time AND created_at <= :end_time",
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
end
