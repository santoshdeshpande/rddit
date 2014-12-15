class Comment < ActiveRecord::Base
	validates_presence_of :body, :user, :link
  belongs_to :user
  belongs_to :link
end
