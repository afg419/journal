class JournalEntry < ActiveRecord::Base
  belongs_to :user
  has_many :emotions

  def datetime
    "#{created_at.month}/#{created_at.day}/#{created_at.year} #{created_at.hour}h"
  end

  def self.in_month(month)

  end

  def self.net_data
    all.reduce({}) do |acc, je|
      acc.merge(je.emotions.scores_to_hash){|k,v1,v2| v1 + v2}
    end.merge({"total" => count})
  end

  def prior_week_entries
    JournalEntry.where("created_at >= :start_date AND created_at <= :end_date",
    {start_date: created_at-7.day, end_date: created_at})
  end
end
