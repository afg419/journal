require 'rails_helper'

RSpec.describe ChartService, type: :model do
  before :each do
    @user = User.create
    @cs = ChartService.new(@user)
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

  it "gets emotion data from user " do
    seed_emotions_user
    @user = mock_login
    create_journal_post([3,2,1], "Journal title1")
    create_journal_post([4,3,2], "Journal title2")
    @cs = ChartService.new(@user)

    data = @cs.get_emotion_data_from_user.emotion_data
    expect(data[@user.id]["happy"][:scores].first[:score]).to eq 4
    expect(data[@user.id]["happy"][:scores][1][:score]).to eq 3

    expect(data[@user.id]["sad"][:scores].first[:score]).to eq 3
    expect(data[@user.id]["sad"][:scores][1][:score]).to eq 2

    expect(data[@user.id]["angry"][:scores].first[:score]).to eq 2
    expect(data[@user.id]["angry"][:scores][1][:score]).to eq 1

    expect(data[@user.id]["angry"][:scores][1][:tag]).to eq "Journal title1"
    expect(data[@user.id]["angry"][:scores][0][:tag]).to eq "Journal title2"
  end

  it "gets emotion data from user for just one emotion" do
    seed_emotions_user
    @user = mock_login
    create_journal_post([3,2,1], "Journal title1")
    create_journal_post([4,3,2], "Journal title2")
    happy = @user.active_emotion_prototypes.find{|x| x.name == "happy"}
    @cs = ChartService.new(@user)

    data = @cs.get_emotion_data_from_user_for([happy]).emotion_data

    expect(data[@user.id]["happy"][:scores].first[:score]).to eq 4
    expect(data[@user.id]["happy"][:scores][1][:score]).to eq 3

    expect(data[@user.id]["happy"][:scores][1][:tag]).to eq "Journal title1"
    expect(data[@user.id]["happy"][:scores][0][:tag]).to eq "Journal title2"
  end

  it "gets emotion data from user for two emotions" do
    seed_emotions_user
    @user = mock_login
    create_journal_post([3,2,1], "Journal title1")
    create_journal_post([4,3,2], "Journal title2")
    happy = @user.active_emotion_prototypes.find{|x| x.name == "happy"}
    sad = @user.active_emotion_prototypes.find{|x| x.name == "sad"}
    @cs = ChartService.new(@user)

    data = @cs.get_emotion_data_from_user_for([happy,sad]).emotion_data

    expect(data[@user.id]["happy"][:scores].first[:score]).to eq 4
    expect(data[@user.id]["happy"][:scores][1][:score]).to eq 3

    expect(data[@user.id]["sad"][:scores].first[:score]).to eq 3
    expect(data[@user.id]["sad"][:scores][1][:score]).to eq 2

    expect(data[@user.id]["angry"]).to eq nil
    expect(data[@user.id]["angry"]).to eq nil

    expect(data[@user.id]["happy"][:scores][1][:tag]).to eq "Journal title1"
    expect(data[@user.id]["happy"][:scores][0][:tag]).to eq "Journal title2"
  end

  it "renders dashboard plot" do
    seed_emotions_user
    @user = mock_login
    create_journal_post([1,2,3], "Journal title1")
    create_journal_post([2,3,4], "Journal title2")
    @cs = ChartService.new(@user)
    @cs.get_emotion_data_from_user

    chart = @cs.render_dashboard_plot
    expect(chart.class).to eq LazyHighCharts::HighChart
  end
end
