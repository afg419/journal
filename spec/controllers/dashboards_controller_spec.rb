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

  it "replies with rendered without given times" do
    user = mock_login
    create_journal_post([0,1,2], "title1", Time.now)
    create_journal_post([0,1,2], "title2",Time.now)

    get :index, "start_date"=>"", "end_date"=>""

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
    create_journal_post([1,7,6,0,0,0],"Post2", Time.now - 3.day)
    create_journal_post([1,7,6,0,0,0],"Post3", Time.now - 5.day)

    params = {"emotions" => {"days" => 2, "happy" => 1}}

    get :index, params

    expect(response.status).to eq 200
  end

  it "replies with rendered graphs given comparison_graph query but larger interval than there is data" do
    user = mock_login
    create_journal_post([1,7,6,0,0,0],"Post1", Time.now)
    create_journal_post([1,7,6,0,0,0],"Post2", Time.now - 3.day)
    create_journal_post([1,7,6,0,0,0],"Post3", Time.now - 5.day)

    params = {"emotions" => {"days" => 10, "happy" => 1}}

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
