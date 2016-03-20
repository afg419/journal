class ChartRenderer
  attr_reader :chart_data, :opts, :colors, :id, :dates

  def initialize(emotion_data, dates, opts = {})
    @emotion_data = emotion_data
    @dates = dates
    @colors = []
    @opts = default_opts.merge(opts)
  end

  def render_dashboard_plot
    LazyHighCharts::HighChart.new('line') do |f|
      @emotion_data.each do |scores_color|
        f.series(scores_color[:scores])
        colors << scores_color[:color]
      end
      dashboard_plot_styling(f)
    end
  end

private

  def dashboard_plot_styling(f)
    f.title(text: opts[:title], align: "center", style: {color: '#EAD9C3', fontSize: opts[:size]})
    f.xAxis(type: 'datetime', min: opts[:x_min], max: opts[:x_max])
    f.colors(colors)
    f.yAxis [
      {title: {text: opts[:y_title], margin: 10, style: {fontSize: "medium", color: '#EAD9C3'} }, min:0, max: 10 , gridLineColor: "rgb(70,70,70)"}
    ]
    f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical', backgroundColor: "rgba(75,75,75,0)" , itemStyle: {
      color: '#EAD9C3'})
    f.chart({defaultSeriesType: "line", backgroundColor: "rgba(0,0,0,0.65)"})
    f.plotOptions({
                        dataLabels: { enabled: true},
               enableMouseTracking: true
                          })
  end

  def default_opts
    {
      title: "Emotions over Time",
      y_title: "Emotion Scores",
      x_min: dates[:start].to_i * 1000,
      x_max: dates[:end].to_i * 1000,
      size: "large"
    }
  end
end
