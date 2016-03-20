class OverallChartService
  attr_reader :data_prep, :renderer, :user

  def initialize(user, dates)
    @user = user
    @data_prep = ChartDataPrepService.new(user, all_emotion_prototypes, dates)
    @renderer = ChartRenderer.new(prepped_data_for_user_on_dates, dates)
  end

  def render_overall_chart
    renderer.render_dashboard_plot
  end

  def all_emotion_prototypes
    user.active_emotion_prototypes
  end

  def prepped_data_for_user_on_dates
    data_prep.emotion_data
  end
end
