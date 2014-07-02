class Follower < ActiveRecord::Base
  attr_accessor :follower_username, :followed_username

  validates_uniqueness_of :user_id, :scope => :followed_user_id
  validate :user_id_not_equal_to_followed_user_id

  private

  def user_id_not_equal_to_followed_user_id
      errors.add(:user_id, "cannot equal followed") unless
          user_id!=followed_user_id
  end 
end
