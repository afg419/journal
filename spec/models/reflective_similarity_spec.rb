require 'rails_helper'

RSpec.describe ReflectiveSimilarity, type: :model do
  before :each do
    seed_emotions_user
  end

  it "fits a curve" do
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
    curve = rs.entries_to_translated_curve(happy, t1, 1.day, @user)
    expect(curve[0]).to eq 1
    expect(curve[1]).to eq 2
  end

  it "fits a more interesting curve" do
    mock_login
    t0 = Time.now - 5.day
    t1 = Time.now - 4.day
    t2 = Time.now - 3.day
    t3 = Time.now - 2.day
    t4 = Time.now - 1.day
    t5 = Time.now

    j0 = create_journal_post([0,0,0], "title0", t0)
    j1 = create_journal_post([1,0,0], "title1", t1)
    j2 = create_journal_post([2,0,0], "title2", t2)
    j3 = create_journal_post([2,0,0], "title3", t3)
    j4 = create_journal_post([1,0,0], "title4", t4)
    j5 = create_journal_post([0,0,0], "title5", t5)
    # binding.pry
    happy = @user.active_emotion_prototypes.first

    rs = ReflectiveSimilarity.new
    curve = rs.entries_to_translated_curve(happy, t0, 6.day, @user)
    expect(curve[0]).to be_within(0.5).of(0)
    expect(curve[1/6.0]).to  be_within(0.5).of(1)
    expect(curve[2/6.0]).to be_within(0.5).of(2)
    expect(curve[3/6.0]).to be_within(0.5).of(2)
    expect(curve[4/6.0]).to be_within(0.5).of(1)
    expect(curve[5/6.0]).to be_within(0.5).of(0)
    expect(curve[1]).to be_within(0.5).of(0)
  end

end
