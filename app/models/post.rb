class Post < ActiveRecord::Base
  attr_reader :vote_stat
  belongs_to :user
  has_many :votes
  has_many :shares

  validates_length_of :content, :minimum => 1, :maximum => 200, :allow_blank => false

  def vote_stat
    self.votes.where("up = ?", true).count - self.votes.where("up = ?", false).count
  end
end
