class Post < ActiveRecord::Base
  attr_accessor :current_user_vote, :current_user_shared
  attr_reader :watch_stat, :ignore_stat, :share_stat
  belongs_to :user
  has_many :votes
  has_many :shares

  validates_length_of :content, :minimum => 1, :maximum => 200, :allow_blank => false

  def watch_stat
    self.votes.where("action = ?", 'watch').count
  end

  def ignore_stat
    self.votes.where("action = ?", 'ignore').count
  end

  def share_stat
    self.shares.count
  end
end
