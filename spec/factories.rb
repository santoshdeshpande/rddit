FactoryGirl.define do
  factory :link do |l|
    sequence(:title) {|n| "link_title_#{n}"}
    sequence(:url) {|n| "link_url_#{n}"}
  end
end