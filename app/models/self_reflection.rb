class SelfReflection

  attr_reader :user, :refl, :cf, :interval, :emotion_prototype

  def initialize(user, interval, emotion_prototype)
    @user = user
    @refl = ReflectiveSimilarity.new(user, interval, emotion_prototype)
    @cf = CurveFit.new
    @interval = interval
    @emotion_prototype = emotion_prototype
  end

  def distances_between_current_interval_and_past_intervals
    tcbi = refl.translated_curves_by_interval
    current = tcbi[-1][0]
    i=0
    tcbi[0..-2].map do |c|
      puts "#{i}"
      i+=1
      [cf.distance_between_curves(0, 1, c[0], current, 2*interval), c[1]]
    end
  end
end
