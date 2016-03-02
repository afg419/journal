class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    @chart = LazyHighCharts::HighChart.new('line') do |f|
      f.title(text: "Emotions", align: "center", style: {color: "rgb(255,255,255)"})
      colors = []
      current_user.emotion_prototypes.each {|emotion_prototype|
        f.series(name: emotion_prototype.name, yAxis: 0, data: current_user.scores_for(emotion_prototype).to_a)
        colors << emotion_prototype.color
      }
      f.xAxis(type: 'datetime')
      f.colors(colors)
      f.yAxis [
        {title: {text: "emotions", margin: 10} }
      ]
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "line", backgroundColor: "rgba(0,0,0,0)"})
    end

    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end
end


# <%= line_chart current_user.emotion_prototypes.map { |emotion_prototype|
#   {
#     name: emotion_prototype.name.capitalize,
#     data: current_user.scores_for(emotion_prototype)
#   }
#   },  library: {backgroundColor: "transparent"} %>
# </div>
