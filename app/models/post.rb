class Post < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
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

  def rating(time)
    (0.0+self.votes.where("action = ? AND created_at < ?", 'watch', time).count-self.votes.where("action = ? AND created_at < ?", 'ignore', time).count)/(DateTime.now.to_f-self.created_at.to_f)
  end
end
