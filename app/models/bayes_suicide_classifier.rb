class BayesSuicideClassifier
  def classifier
    @@classifier ||= train_on_training_posts
  end

  def train_on_training_posts
    classy = Classifier::Bayes.new 'Ok', 'Troubled'
    TrainingPost.all.each do |tp|
      classy.send(keys_to_methods[tp.classification.downcase], tp.entry)
    end
    classy
  end

  def reset_classifier
    @@classifier = nil
  end

  def classify(string)
    classifier.classify(string)
  end

  def keys_to_methods
    {
      "ok" => :train_ok,
      "troubled" => :train_troubled
    }
  end

  # def train_on_db
  #   classy = Classifier::Bayes.new 'ok', 'troubled'
  #   classy.categories = WatchClassifier.first.categories
  #   classy
  # end
end

# class Classifier::Bayes
#   attr_reader :total_words, :categories
#   attr_accessor :category_counts
# end
