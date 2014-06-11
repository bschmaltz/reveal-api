class FollowersController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @follower = Follower.new(follower_params)
    if !@user.nil? and follower_params[:user_id]==@user.id and @follower.save
      @result = true
    else
      @result = false
    end
  end

  def get_followers_for_user
    @followers = Follower.where('followed_user_id = ?', params[:user_id])

    @followers.each do |follower|
      follower_username = User.find(follower.user_id).username
      follower.assign_attributes({ :follower_username => follower_username })
    end
  end

  def get_followed_for_user
    @followers = Follower.where('user_id = ?', params[:user_id])

    @followers.each do |follower|
      followed_username = User.find(follower.followed_user_id).username
      follower.assign_attributes({ :followed_username => followed_username })
    end
  end

  def destroy
    @user = authenticate_token
    @follower = Follower.find(params[:id])
    if !@user.nil? and !@follower.nil? and @follower.user_id==@user.id and @follower.destroy
      @result = true
    else
      @result = false
    end
  end

  private

  def follower_params
    params.require(:follower).permit(:user_id, :followed_user_id)
  end
end
