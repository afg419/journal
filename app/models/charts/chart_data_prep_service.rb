class ChartDataPrepService
  attr_reader :user, :start, :finish, :emotion_prototypes, :emotion_data

  def initialize(user, emotion_prototypes, dates)
    @user = user
    @start = dates[:start]
    @finish = dates[:end]
    @emotion_prototypes = emotion_prototypes
    @emotion_data = get_and_format_data_for_chart
  end

  def get_and_format_data_for_chart
    get_emotion_data_from_user.map do |emotion_name, color_scores|
      {
        scores: {
                name: emotion_name,
                yAxis: 0,
                data: relabel(color_scores[:scores]),
                dataLabels: {enabled: true, format: "{name}"}
              },
        color: color_scores[:color]
      }
    end
  end

  def get_emotion_data_from_user
    data = user.chart_emotion_data(start, finish, emotion_prototypes)
    id = data.keys.first
    data[id]
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
