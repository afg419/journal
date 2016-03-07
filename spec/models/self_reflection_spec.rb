require 'rails_helper'

RSpec.describe ReflectiveSimilarity, type: :model do
  before :each do
    seed_emotions_user
  end

  it "extracts time scores from scores" do
    mock_login
    t0 = Time.now - 3.day
    t1 = Time.now - 1.day
    t2 = Time.now

    j0 = create_journal_post([0,1,2], "title0", t0)
    j1 = create_journal_post([1,1,2], "title1", t1)
    j2 = create_journal_post([2,1,2], "title2", t2)
    # binding.pry
    happy = @user.active_emotion_prototypes.first

    rs = ReflectiveSimilarity.new
    curve = rs.entries_to_translated_curve(happy, t1, 1.day, @user, 7)
    expect(curve[0]).to eq 1
    expect(curve[1]).to eq 2
  end
end
