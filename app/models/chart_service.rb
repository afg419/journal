class ChartService
  attr_reader :emotion_data, :colors, :id, :user

  def initialize(user)
    @user = user
    @id = user.id
    @colors = []
    @emotion_data = {@id => []}
  end

  def get_emotion_data_from_user(start_time = nil, end_time = nil)
    start_time ||= user.journal_entries.first.created_at - 1.day
    end_time ||= user.journal_entries.last.created_at + 1.day
    @emotion_data = user.chart_emotion_data(start_time, end_time)
  end

  def get_emotion_data_from_user_for(emotion_prototype, start_time=nil, end_time=nil)
    start_time ||= user.journal_entries.first.created_at - 1.day
    end_time ||= user.journal_entries.last.created_at + 1.day
    {
      id => {
            emotion_prototype.name =>
              {
                color: emotion_prototype.color,
                scores: user.scores_for(emotion_prototype, start_time, end_time)
              }
            }
    }
  end

  def render_dashboard_plot
    LazyHighCharts::HighChart.new('line') do |f|
      emotion_data[id].each do |emotion_name, color_scores|
        f.series(name: emotion_name,
                yAxis: 0,
                 data: relabel(color_scores[:scores]),
                 dataLabels: {enabled: true, format: "{name}"})
        colors << color_scores[:color]
      end
      dashboard_plot_styling(f)
    end
  end

  def dashboard_plot_styling(f)
    f.title(text: "Emotions over Time", align: "center", style: {color: '#EAD9C3', fontSize: "large"})
    f.xAxis(type: 'datetime')
    f.colors(colors)
    f.yAxis [
      {title: {text: "Emotion Scores", margin: 10, style: {fontSize: "medium", color: '#EAD9C3'} }, min:0, max: 10 , gridLineColor: "rgb(70,70,70)"}
    ]
    f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical', backgroundColor: "rgba(75,75,75,0)" , itemStyle: {
      color: '#EAD9C3'})
    f.chart({defaultSeriesType: "line", backgroundColor: "rgba(0,0,0,0.65)"})
  end

  def relabel(scores)
    dict = {created_at: :x, score: :y, tag: :name}
    scores.compact.map do |hash|
      hash.map do |k,v|
        [dict[k],adjust_date_times(v)]
      end.to_h
    end
  end

  def adjust_date_times(dt)
    if dt.class == ActiveSupport::TimeWithZone
      (dt.to_f * 1000).to_i
    else
      dt
    end
  end
end
