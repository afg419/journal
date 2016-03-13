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
end
