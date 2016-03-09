module UserHelper

  def scores_for(emotion_prototype, start_time, end_time)
    journal_entries.scores_for(emotion_prototype, start_time, end_time)
  end

  def formatted_scores_for(emotion_prototype, start_time, end_time)
    {
      emotion_prototype.name => {
        color: emotion_prototype.color,
        scores: scores_for(emotion_prototype, start_time, end_time)
      }
    }
  end

  def chart_emotion_data(start_time, end_time, emotion_protos=nil)
    emotion_protos ||= emotion_prototypes.all
    {id => emotion_protos.reduce({}) do |acc, emotion_prototype|
      acc.merge(formatted_scores_for(emotion_prototype, start_time, end_time))
    end}
  end

  def journal_entries?
    journal_entries.count > 0
  end

  def scores_for_emp_with_endpoints(emotion_prototype, start_time, end_time)
    scores = scores_for(emotion_prototype, start_time, end_time)
    left = journal_entries.closest_entry_to(start_time)
    right = journal_entries.closest_entry_to(end_time)

    left_em = left.emotions.find_by(emotion_prototype: emotion_prototype)
    right_em = right.emotions.find_by(emotion_prototype: emotion_prototype)

    scores += [{created_at: start_time, score: left_em.score, tag: left.tag},
               {created_at: end_time, score: right_em.score, tag: right.tag}]
               binding.pry
    scores.sort_by{|score| score[:created_at]}
  end

end
