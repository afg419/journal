require 'rails_helper'

RSpec.describe CurveFit, type: :model do
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
    cv = CurveFit.new
    reply = [ {:x=>t2.to_i, :y=>0},
             {:x=>t1.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0},
             {:x=>t0.to_i, :y=>0}]
    expect(cv.extract_time_score(scores)).to eq reply
  end

  it "creates a hypothesis function based on coefficients" do
    theta = [1, 1, 1]
    cv = CurveFit.new
    expect(cv.hyp[theta][0]).to eq 1
    expect(cv.hyp[theta][1]).to eq 3
    expect(cv.hyp[theta][-1]).to eq 1
  end

  it "computes cost function" do
    t0 = Time.now
    t1 = Time.now - 1.day
    t2 = Time.now - 3.day
    extracted_scores = [{x: 0, :y=>0},
                        {x: 1, :y=>0},
                        {x: -1, :y=>0}]


    theta = [1, 1, 1]
    cv = CurveFit.new
    cost = cv.cost(extracted_scores)[theta]
    expect(cost).to eq 11/6.to_f
  end

  it "computes cost function for cubic poly" do
    extracted_scores = [{x: 0, :y=>0},
                        {x: 1, :y=>0},
                        {x: -1, :y=>0}]


    theta = [1, 0, 0, 1]
    cv = CurveFit.new
    cost = cv.cost(extracted_scores)[theta]
    expect(cost).to eq 5/6.to_f
  end

  it "fits linear poly to data" do
    extracted_scores = [{x: 0, :y=>0},
                        {x: 1, :y=>0},
                        {x: -1, :y=>0}]
    cv = CurveFit.new
    line = cv.best_fit(1,extracted_scores)
    expect(line).to eq [0,0]
  end

  it "fits quadratic poly to data" do
    extracted_scores = [{x: 0, :y=>0},
                        {x: 1, :y=>1},
                        {x: -1, :y=>1},
                        {x: -2, :y=>4},
                        {x: 2, :y=>4}]
    cv = CurveFit.new
    quad = cv.best_fit(2, extracted_scores)
    expect(quad).to eq [0,0,1]
  end

  it "fits quadratic poly to data with constant" do
    extracted_scores = [{x: 0, :y=>1},
                        {x: 1, :y=>2},
                        {x: -1, :y=>2},
                        {x: -2, :y=>5},
                        {x: 2, :y=>5}]
    cv = CurveFit.new
    quad = cv.best_fit(2, extracted_scores)
    expect(quad).to eq [1,0,1]
  end

  it "returns best fit curve" do
    extracted_scores = [{x: 0, :y=>1},
                        {x: 1, :y=>2},
                        {x: -1, :y=>2},
                        {x: -2, :y=>5},
                        {x: 2, :y=>5}]
    cv = CurveFit.new
    quad = cv.best_curve(2, extracted_scores)
    expect(quad[0]).to eq 1
    expect(quad[1]).to eq 2
    expect(quad[-1]).to eq 2
    expect(quad[-2]).to eq 5
    expect(quad[2]).to eq 5
  end

  it "returns translated curve" do
    extracted_scores = [{x: 0, :y=>1},
                        {x: 1, :y=>2},
                        {x: -1, :y=>2},
                        {x: -2, :y=>5},
                        {x: 2, :y=>5}]
    cv = CurveFit.new
    quad = cv.best_curve(2, extracted_scores)
    trans_quad = cv.translate_curve_left(quad, 2)

    expect(trans_quad[-2]).to eq 1
    expect(trans_quad[-1]).to eq 2
    expect(trans_quad[-3]).to eq 2
    expect(trans_quad[-4]).to eq 5
    expect(trans_quad[0]).to eq 5
  end

  it "measures distance between curves" do
    f = Proc.new{|x| x}
    g = Proc.new{|x| 1}
    cv = CurveFit.new
    dist = cv.distance_between_curves(0,2,f,g)
    expect(dist).to eq 1
  end
end
