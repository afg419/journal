class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    @chart = LazyHighCharts::HighChart.new('line') do |f|
      f.title(text: "Emotions", align: "center", style: {color: '#EAD9C3', fontSize: "large"})
      colors = []
      current_user.emotion_prototypes.each {|emotion_prototype|
        f.series(name: emotion_prototype.name, yAxis: 0, data: current_user.scores_for(emotion_prototype).to_a)
        #data in the previous method takes a lot of formats... I think any of the following works: [[x1,y1],[x2,y2]] [{x1 => y1}, {x2 => y2}] {x1 =>y1 , x2 => y2}
        colors << emotion_prototype.color
      }
      f.xAxis(type: 'datetime')
      f.colors(colors)
      f.yAxis [
        {title: {text: "Emotion Scores", margin: 10, style: {fontSize: "medium", color: '#EAD9C3'} }, min:0, max: 10 , gridLineColor: "rgb(70,70,70)"}
      ]
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical', backgroundColor: "rgba(75,75,75,0)" , itemStyle: {
                color: '#EAD9C3'})
      f.chart({defaultSeriesType: "line", backgroundColor: "rgba(0,0,0,0.65)"})
    end

    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end
end
