FactoryGirl.define do
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
