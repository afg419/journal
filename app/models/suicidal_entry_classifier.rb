class SuicidalEntryClassifier
  attr_reader :entry_data, :bayes_classifier, :sentiment_analyzer

  def initialize(post_with_data)
    Sentimental.load_defaults
    @sentiment_analyzer = Sentimental.new(0.1)
    @bayes_classifier = BayesSuicideClassifier.new
    @entry_data = post_with_data
  end

  def troubled_past_week?
    entry_data = Hash.new(0).merge(JournalEntry.last.prior_week_entries.net_data)
    4 * entry_data["content"] + 2*entry_data["happy"] < entry_data["sad"] + entry_data["angry"] + entry_data["anxious"]
  end

  def troubled_classification?
    {"Ok" => false, "Troubled" => true}[bayes_classifier.classify entry_data["body"]]
  end

  def troubled_sentiment? #toggled neutral+positive to true, sentimental not doing what I want atm.
    {
      :neutral => true,
      :positive => true,
      :negative => true
    }[sentiment_analyzer.get_sentiment(entry_data["body"])]
  end

  def troubled?
    troubled_past_week? && troubled_classification? && troubled_sentiment?
  end
end
