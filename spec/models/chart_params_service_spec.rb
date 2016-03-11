require 'rails_helper'

RSpec.describe ChartParamsService, type: :model do

  before :each do
    seed_emotions_user
    mock_login
    create_journal_post([1,7,6],"Post1", Time.now)
    @cps = ChartParamsService.new(@user,{})
  end

  it "checks whether comparison graph queried" do
    @cps.params = {"emotions" => {"days" => 1, "happy" => 1}}
    expect(@cps.comparison_graph?)
  end

  it "checks datetime params when passed params" do
    t0 = "4/19/1989"
    t1 = "4/29/1989"
    @cps.params = {"start_date" => t0, "end_date" => t1}

    expected =  {start: Time.strptime(t0, "%m/%d/%Y"),
                   end: Time.strptime(t1, "%m/%d/%Y")}

    expect(@cps.datetime_params).to eq expected
  end

  it "checks datetime params when not passed params" do
    t1 = JournalEntry.last.created_at
    t0 = t1 - 1.month
    expect(@cps.datetime_params).to eq ({start: t0, end: t1})
  end

  it "computes emotion params" do
    t1 = JournalEntry.last.created_at
    t0 = t1 - 1.month

    @cps.params = {"emotions" => {"happy" => 1, "sad" => 0}}
    expect(@cps.emotion_params).to eq [happy]
  end

end
