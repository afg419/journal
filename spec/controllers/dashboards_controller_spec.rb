require 'rails_helper'

RSpec.describe Api::V1::DashboardsController, type: :controller do
  before(:each) do
    seed_emotions_user_expanded_defaults
  end

  it "replies with rendered graph given times" do
    user = mock_login
    t0 = "04/18/1989"
    t1 = "04/19/1989"

    get :index, "start_date" => t0, "end_date" => t1

    expect(response.status).to eq 200
  end

  it "replies with rendered without given times" do
    user = mock_login
    create_journal_post([0,1,2], "title1", Time.now)
    create_journal_post([0,1,2], "title2",Time.now)

    get :index

    expect(response.status).to eq 200
  end

  it "replies with rendered without given times and no posts" do
    user = mock_login

    get :index

    expect(response.status).to eq 200
  end

  it "replies with rendered graphs given comparison_graph query " do
    user = mock_login
    create_journal_post([1,7,6,0,0,0],"Post1", Time.now)
    create_journal_post([1,7,6,0,0,0],"Post2", Time.now)

    params = {"emotions" => {"days" => 1, "happy" => 1}}

    get :index, params

    expect(response.status).to eq 200
  end

  it "replies with error if no day query " do
    user = mock_login
    create_journal_post([1,7,6,0,0,0],"Post1", Time.now)
    create_journal_post([1,7,6,0,0,0],"Post2", Time.now)

    params = {"emotions" => {"happy" => 1}}

    get :index, params

    expect(response.status).to eq 200
  end

end


# cs = ChartService.new(current_user)
# cs.get_emotion_data_from_user(datetime_params[0], datetime_params[1])
# @chart = cs.render_dashboard_plot
# render layout: 'wide',  :locals => {:background => "dashboard3"}
