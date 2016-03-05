require 'rails_helper'

RSpec.describe JournalEntry, type: :model do
  it "replies with datetime" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    je = JournalEntry.create(created_at: now)
    expect(je.datetime).to eq "2/10/2007 15h"
  end

  it "computes net data and serves up as a hash" do
    seed_emotions_user
    create_journal_post([1,2,3],"Entry1")
    create_journal_post([3,5,8],"Entry2")

    net_data = {
      "happy" => 4,
      "sad" => 7,
      "angry" => 11,
      "total" => 2
    }

    expect(JournalEntry.net_data).to eq net_data
  end

  it "gives prior week" do
    now = Time.zone.parse('2007-02-10 15:30:45')
    week_prior = Time.zone.parse('2007-02-3 15:30:45')
    even_earlier = Time.zone.parse('2007-02-1 15:30:45')

    seed_emotions_user
    create_journal_post([1,2,3],"Entry1 In week", now)
    create_journal_post([3,5,8],"Entry2 In week", week_prior)
    create_journal_post([4,4,4],"Entry3 Out of week", even_earlier)

    most_recent = JournalEntry.find_by(tag: "Entry1 In week")
    weeks_tags = most_recent.prior_week_entries.all.map{|x| x.tag}
    expect(weeks_tags).to eq ["Entry1 In week", "Entry2 In week"]
  end
end
