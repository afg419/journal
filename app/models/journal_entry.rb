class JournalEntry < ActiveRecord::Base
  belongs_to :user
  has_many :emotions
end
