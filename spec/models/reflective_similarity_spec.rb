require 'rails_helper'

RSpec.describe ReflectiveSimilarity, type: :model do
  before :each do
    seed_emotions_user
  end

  it "extracts time scores from scores" do
    mock_login
    t0 = Time.now
    t1 = Time.now - 1.day
    t2 = Time.now - 3.day

    j0 = create_journal_post([0,1,2], "title0", t0)
    j1 = create_journal_post([0,1,2], "title1", t1)
    j2 = create_journal_post([0,1,2], "title2", t2)

    rs = ReflectiveSimilarity.new(@user, 1)

    happy = @user.active_emotion_prototypes.first
    scores = @user.scores_for_emp_with_endpoints(happy, (Time.now-3.day), Time.now)
    reply = [ {:x=>t2.to_i, :y=>0},
             {:x=>t1.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0}]
    expect(rs.extract_time_score(scores)).to eq reply
  end

  it "converts scores to intervals" do
    mock_login
    now = Time.now
    t0 = now - 15.day
    t1 = now - 12.day
    t2 = now - 9.day
    t3 = now - 6.day
    t4 = now - 3.day
    t5 = now

    j0 = create_journal_post([0,0,0], "title0", t0)
    j1 = create_journal_post([1,0,0], "title1", t1)
    j2 = create_journal_post([2,0,0], "title2", t2)
    j3 = create_journal_post([3,0,0], "title3", t3)
    j4 = create_journal_post([4,0,0], "title4", t4)
    j5 = create_journal_post([5,0,0], "title5", t5)

    happy = @user.emotion_prototypes.find_by(name: "happy")
    rs = ReflectiveSimilarity.new(@user, 7, happy)
    intervals = rs.scores_by_interval.map{|interval| interval.map{|day| day[:tag]}}
    expected_intervals = [["title0", "title1", "title2"],
                          ["title1", "title2"],
                          ["title1", "title2"],
                          ["title1", "title2", "title3"],
                          ["title2", "title3"],
                          ["title2", "title3"],
                          ["title2", "title3", "title4"]]
    expect(intervals).to eq expected_intervals
  end

  it "translates and scales extracted scores" do
    t0 = DateTime.now
    t1 = t0 + 1.day
    t2 = t0 + 3.day
    
    extracted_scores =  [{:x => t2.to_i, :y=>0},
                         {:x => t1.to_i, :y=>1},
                         {:x => t0.to_i, :y=>0}].reverse

    rs = ReflectiveSimilarity.new(nil, 3)

    reply = rs.translate_scale_extracted_scores(extracted_scores, t0.to_i).sort_by{|score| score[:x]}

    expect(reply.first[:x].round(1)).to eq 0
    expect(reply.first[:y].round(1)).to eq 0
    expect(reply[1][:x]).to eq 1/3.0
    expect(reply[1][:y].round(1)).to eq 1
    expect(reply.last[:x].round(1)).to eq 1
    expect(reply.last[:y].round(1)).to eq 0
  end

  it "translates scores to translated piece-wise linear" do
    t0 = Time.now
    t1 = t0 + 1.day
    t2 = t0 + 3.day

    scores =  [{:created_at=>t2.to_i, :score=>0, tag: "title2"},
               {:created_at=>t1.to_i, :score=>1, tag: "title1"},
               {:created_at=>t0.to_i, :score=>0, tag: "title0"}].reverse

    rs = ReflectiveSimilarity.new(nil, 3)
    plc = rs.scores_to_translated_curve(scores, t0.to_i)
    #Note in some sense these scores are lucky.  This is because we have set the interval
    # to be precisecly the distance between t0 and t2.  In general plc[1] will not correspond to
    # the y value of the last time.
    expect(plc.class).to eq Proc
    expect(plc[0]).to eq 0
    expect(plc[1/6.0].round(1)).to eq 0.5
    expect(plc[(1/3.0)]).to eq 1
    expect(plc[(2/3.0)].round(1)).to eq 0.5
    expect(plc[1].round(1)).to eq 0
  end

  it "translates an emp, interval, and user, to a collection of curves" do
    mock_login
    now = Time.now
    t0 = now - 15.day
    t1 = now - 12.day
    t2 = now - 9.day
    t3 = now - 6.day
    t4 = now - 3.day
    t5 = now

    j0 = create_journal_post([0,0,0], "title0", t0)
    j1 = create_journal_post([1,0,0], "title1", t1)
    j2 = create_journal_post([1,0,0], "title2", t2)
    j3 = create_journal_post([2,0,0], "title3", t3)
    j4 = create_journal_post([2,0,0], "title4", t4)
    j5 = create_journal_post([4,0,0], "title5", t5)

    happy = @user.active_emotion_prototypes.find_by(name: "happy")
    rs = ReflectiveSimilarity.new(@user, 7, happy)
    pwls = rs.translated_curves_by_interval

    expect(pwls[0].first[0]).to eq 0
    expect(pwls[0].first[0.5]).to eq 1
    expect(pwls[0].first[1]).to eq 1
  end
end
