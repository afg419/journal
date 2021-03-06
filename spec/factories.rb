FactoryGirl.define do
  factory :app_message do
    message "MyText"
    user nil
    status 1
  end
  factory :training_post do
    entry "MyText"
    classification "MyString"
  end
  factory :user_emotion_prototype do
    user nil
    emotion_prototype nil
  end
  
  factory :emotion do
    score 1
    journal_entry nil
    emotion_prototype nil
  end

  factory :emotion_prototype do
    name "MyString"
    description "MyString"
    color "MyString"
  end

  factory :journal_entry do
    tag "MyString"
    body "MyString"
    file_id "MyString"
    user nil
  end

  factory :user do
    name "MyString"
    email "MyString"
  end
end
