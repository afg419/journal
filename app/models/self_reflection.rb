class SelfReflection

  attr_reader :user, :refl

  def initialize(user)
    @user = user
    @refl = ReflectiveSimilarity.new
  end

  def distances_between_journal_and_journal_span(emotion_prototype, interval, user)
    end_time = Time.now.to_i - interval
    current_curve = refl.entries_to_translated_curve(emotion_prototype,
                                                      end_time,
                                                     interval,
                                                     user)
    past_curves(emotion_prototype, end_time, interval, user).min do |curve|
      refl.cf.distance_between_curves(0, interval, current_curve, curve)
    end
  end

  def past_curves(emotion_prototype, end_time, interval, user)
    t0 = user.first_entry_date.to_i
    t1 = interval
    curves = []
    while t1 < interval
      curves << refl.entries_to_translated_curve(emotion_prototype, t0, t1 - t0, user)
      t0 += 1.day
      t1 += 1.day
    end
  end
end


# 1. Methods for, given a week timeframe, create false data points on the edges: id closest posts in time, take their score for the emotion.
# 2. Given a timeframe augmented by endpoints as above, best fit 5d-7d polynomial to the week’s data points.  Need cost function for 7d poly and variable length training set.  This uses the minimization gem.  e.g…
# 		f = proc{ |x| (x[0] - @p[0])**2 + (x[1] - @p[1])**2 + (x[2] - @p[2])**2 }
# 		@min1 = Minimization::NelderMead.minimize(f, @start_point)
# 	We want f = proc{|theta| sum_i((poly_theta(xi) - yi)**2)
# 	This returns theta vector of best fitting curve.
# 3. Perform step 2 on most recent week.  Then begin at the first journal entry in time, and proceed as follows.
#     1. Compute step 2 on the current week.
#     2. let f be the proc corresponding to the best fit curve for current week, and g the proc for best fit curve to week examined.
#     3. h = Proc.new {|x| [f[x],g[x]].max}, j = Proc.new{|x| [f[x],g[x]].min}
#     4. Integrate h-j over the time ranges of the week…. e.g
#     5. Integration.integrate(time_0, time_1, {:tolerance=>1e-10,:method=>:simpson}) {|x| h[x]-j[x]}
#     6. Store this number in an array and repeat this process one day later
#     7. Stop when the right end point is the left end point of the current week
#     8. the LOWEST numbers in the array represent the most similar time periods for that emotion.
