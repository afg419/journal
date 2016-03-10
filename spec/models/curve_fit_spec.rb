require 'rails_helper'

RSpec.describe CurveFit, type: :model do
  before :each do
    seed_emotions_user
    @cf = CurveFit.new
    @points = [
      {x:0 , y:0},
      {x:1 , y:1},
      {x:2 , y:0},
      {x:3 , y:0},
      {x:4 , y:-1},
      {x:5 , y:-3},
      {x:6 , y:6}
    ]
  end

  it "measures slope between two points" do
    p1, p2, p3 = @points[0..2]
    expect(@cf.slope(p1, p2)).to eq 1
    expect(@cf.slope(p2, p3)).to eq -1
    expect(@cf.slope(p1, p3)).to eq 0
  end

  it "creates line between two points" do
    p1, p2, p3 = @points[0..2]
    p4 = @points[4]

    l12 = @cf.line_between(p1,p2)
    l23 = @cf.line_between(p2,p3)
    l13 = @cf.line_between(p1,p3)
    l14 = @cf.line_between(p1,p4)

    samples = [-1, -0.5, 0, 0.5, 1, 1.5 , 2]
    samples.each do |s|
      expect(l12[s]).to eq s
      expect(l23[s]).to eq -s + 2
      expect(l13[s]).to eq 0
      expect(l14[s]).to eq -0.25*s
    end
  end


  it "creates segments" do
    p1, p2 = @points[0..1]
    seg = @cf.segment(p1,p2)
    expect(seg[:a]).to eq p1
    expect(seg[:b]).to eq p2

    samples = [-1, -0.5, 0, 0.5, 1, 1.5 , 2]
    samples.each do |s|
      expect(seg[:ab][s]).to eq s
    end
  end

  it "creates piece_wise_line" do
    p1, p2, p3 = @points[0..2]
    segs = [@cf.segment(p1,p2), @cf.segment(p2,p3)]
    pwl = @cf.piece_wise_line(segs)

    expect(pwl[-100]).to eq -100
    expect(pwl[-1]).to eq -1
    expect(pwl[-0.5]).to eq -0.5
    expect(pwl[0]).to eq 0
    expect(pwl[0.5]).to eq 0.5
    expect(pwl[1]).to eq 1
    expect(pwl[1.5]).to eq 0.5
    expect(pwl[2]).to eq 0
    expect(pwl[100]).to eq -98
  end

  it "creates piece-wise line out of ordered points" do
    pwl = @cf.ordered_points_to_piece_wise_line(@points)

    expect(pwl[-100]).to eq -100
    expect(pwl[-1]).to eq -1
    expect(pwl[-0.5]).to eq -0.5
    expect(pwl[0]).to eq 0
    expect(pwl[0.5]).to eq 0.5
    expect(pwl[1]).to eq 1
    expect(pwl[1.5]).to eq 0.5
    expect(pwl[2]).to eq 0
    expect(pwl[2.5]).to eq 0
    expect(pwl[3]).to eq 0
    expect(pwl[3.5]).to eq -0.5
    expect(pwl[4]).to eq -1
    expect(pwl[4.5]).to eq -2
    expect(pwl[5]).to eq -3
    expect(pwl[5.5]).to eq 1.5
    expect(pwl[6]).to eq 6
    expect(pwl[100]).to eq 94*9 + 6
  end


  it "measures distance between curves" do
    f = Proc.new{|x| 1}
    g = Proc.new{|x| 2}

    dist = @cf.distance_between_curves(0,2,f,g,1)
    expect(dist).to eq 2
    dist = @cf.distance_between_curves(0,2,f,g,10)
    expect(dist).to eq 2


    f = Proc.new{|x| x}
    g = Proc.new{|x| 1}
    dist = @cf.distance_between_curves(0,2,f,g,1)
    expect(dist).to eq 2
    dist = @cf.distance_between_curves(0,2,f,g,2)
    expect(dist).to eq 1
    dist = @cf.distance_between_curves(0,2,f,g,4)
    expect(dist).to eq 1
    dist = @cf.distance_between_curves(0,2,f,g,20)
    expect(dist).to eq 1

    f = Proc.new{|x| x/2.0}
    g = Proc.new{|x| 3*x + 1}
    dist = @cf.distance_between_curves(0,2,f,g,40)
    expect(dist).to eq 7.125
    dist = @cf.distance_between_curves(0,2,f,g, 100)
    expect(dist.round(2)).to be_within(0.5).of(7.0)



  end
end
