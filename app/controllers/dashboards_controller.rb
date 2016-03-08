class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    cs = ChartService.new(current_user)
    if current_user.journal_entries?
      cs.get_emotion_data_from_user(datetime_params[0], datetime_params[1])
    end
    @chart = cs.render_dashboard_plot
    
    @chart2 = cs.render_dashboard_plot
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  private

  def datetime_params
    if (start = params["start_date"]) && (finish = params["end_date"])
      start_date = Time.strptime(start, "%m/%d/%Y")
      end_date =  Time.strptime(finish, "%m/%d/%Y")
    else
      start_date = current_user.first_entry_date
      end_date =  current_user.last_entry_date
    end
      [start_date, end_date]
  end
end
