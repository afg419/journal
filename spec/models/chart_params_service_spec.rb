require 'rails_helper'

RSpec.describe ChartParamsService, type: :model do

  before :each do
    seed_emotions_user
    mock_login
    create_journal_post([1,7,6],"Post1", Time.now)
    @cps = ChartParamsService.new(@user)
  end

  it "checks whether comparison graph queried" do
    @cps.params = {"emotions" => {"days" => 1, "happy" => 1}}
    expect(@cps.comparison_graph?)
  end

  # it "checks datetime params" do
  #   t0 = Time.now
  #   t1 = t0 + 1
  #   @cps.params = {"start_date" => t0, "end_date" => t1}
  #   expect(@cps.datetime_params)
  # end

end
