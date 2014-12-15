FactoryGirl.define do  

  
  factory :user do | u |
    sequence(:name) {|n| "name#{n}"}  
  	sequence(:email) {|n| "email#{n}@santoshs.com"}  
  	u.password 'password'

  end

  factory :link do |l|
    sequence(:title) {|n| "link_title_#{n}"}
    sequence(:url) {|n| "link_url_#{n}"}
  end

  factory :invalid_link, parent: :link do | l |
    l.title nil
  end

  factory :comment do |c|
    sequence(:body) {|n| "random text for the link #{n}"}
    c.user FactoryGirl.build(:user)
    c.link FactoryGirl.build(:link)
  end

end