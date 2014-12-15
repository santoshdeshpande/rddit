class Link < ActiveRecord::Base
  acts_as_votable	
  validates_presence_of :title, :url
  belongs_to :user


  def vote_count
  	votes_for.size
  end

  def upvote_count
  	get_upvotes.size
  end

  def downvote_count
  	get_downvotes.size
  end

end
