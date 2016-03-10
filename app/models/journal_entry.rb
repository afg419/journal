class JournalEntry < ActiveRecord::Base
  belongs_to :user
  has_many :emotions

  def datetime
    "#{created_at.month}/#{created_at.day}/#{created_at.year} #{created_at.hour}h"
  end

  def self.net_data
    Emotion.where(journal_entry: self.all).scores_to_hash.merge({"total" => count})
  end

  # def mt_created_at
  #   created_at -= 7.hour
  # end

  def prior_week_entries
    JournalEntry.where("created_at >= :start_date AND created_at <= :end_date",
    {start_date: created_at-7.day, end_date: created_at, user_id: user_id})
  end

  def self.closest_entry_to(time)
    all.sort_by{|je| (je.created_at - time)**2}.first
  end

  def self.scores_for(emotion_prototype, start_time, end_time)
    entries = where("created_at >= :start_time AND created_at <= :end_time",  {start_time: start_time, end_time: end_time}).all
    emps = Emotion.order(created_at: :desc)
                  .includes(:journal_entry)
                  .includes(:emotion_prototype)
                  .where(emotion_prototype: emotion_prototype, journal_entry: entries)
                  .map do |emp|
                    {
                      created_at: emp.journal_entry.created_at,
                      score: emp.score,
                      tag: emp.journal_entry.tag
                    }
                  end
  end
end
