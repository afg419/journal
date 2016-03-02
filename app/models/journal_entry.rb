class JournalEntry < ActiveRecord::Base
  belongs_to :user
  has_many :emotions

  def datetime
    "#{created_at.month}/#{created_at.day}/#{created_at.year} #{created_at.hour}h"
  end

  def self.in_month(month)

  end
end
