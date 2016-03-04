require 'rails_helper'

RSpec.describe ChartService, type: :model do
  before :each do
    @user = User.create
    @cs = ChartService.new(@user)
  end


  it "relabels scores" do
    times = [ActiveSupport::TimeWithZone.new(1,1), ActiveSupport::TimeWithZone.new(1,2)]
    scores = [{created_at: times[0], score: 6, tag: "frank"},
              {created_at: times[1], score: 7, tag: "charles"}]
    relabeled = @cs.relabel(scores)

    expect(relabeled.first[:x].class).to eq Fixnum
    expect(relabeled.first[:y]).to eq 6
    expect(relabeled.first[:name]).to eq "frank"

    expect(relabeled[1][:x].class).to eq Fixnum
    expect(relabeled[1][:y]).to eq 7
    expect(relabeled[1][:name]).to eq "charles"

  end

  it "adjust date times to unix" do
    time = ActiveSupport::TimeWithZone.new(1,1)
    expect(@cs.adjust_date_times(time).class).to eq Fixnum
  end

  it "doesn't do anything to non date times" do
    time = "hey"
    expect(@cs.adjust_date_times(time)).to eq "hey"

    time = 6
    expect(@cs.adjust_date_times(time)).to eq 6
  end
end
