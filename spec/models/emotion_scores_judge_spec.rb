require 'rails_helper'

RSpec.describe EmotionScoresJudge, type: :model do
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

    happy = @user.active_emotion_prototypes.first
    scores = @user.scores_for_emp_with_endpoints(happy, (Time.now-3.day), Time.now)
    esj = EmotionScoresJudge.new
    reply = [ {:x=>t2.to_i, :y=>0},
             {:x=>t1.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0}]
    expect(esj.extract_time_score(scores)).to eq reply
  end

  it "creates a hypothesis function based on coefficients" do
    theta = [1, 1, 1]
    esj = EmotionScoresJudge.new
    expect(esj.hyp[theta][0]).to eq 1
    expect(esj.hyp[theta][1]).to eq 3
    expect(esj.hyp[theta][-1]).to eq 1
  end

  it "computes cost function" do
    t0 = Time.now
    t1 = Time.now - 1.day
    t2 = Time.now - 3.day
    extracted_scores = [{x: 0, :y=>0},
                        {x: 1, :y=>0},
                        {x: -1, :y=>0}]


    theta = [1, 1, 1]
    esj = EmotionScoresJudge.new
    cost = esj.cost(extracted_scores)[theta]
    expect(cost).to eq 11/6.to_f
  end
end
