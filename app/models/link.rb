class Link < ActiveRecord::Base
  validates_presence_of :title, :url
  belongs_to :user
end
