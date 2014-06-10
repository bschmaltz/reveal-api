class VotesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @vote = Vote.new(vote_params)
    @post = Post.find(vote_params[:post_id])
    if !@user.nil? and !@post.nil? and @post.user_id!=vote_params[:user_id] and @user.id==vote_params[:user_id] and @vote.save
      @result = true
    else
      @result = false
    end
  end

  def destroy
    @user = authenticate_token
    @vote = Vote.find_by_user_id_and_post_id(params[:user_id], params[:post_id])
    if !@user.nil? and !@vote.nil? and @vote.user_id==@user.id and @vote.destroy
      @result = true
    else
      @result = false
    end
  end

  def update
    @user = authenticate_token
    @vote = Vote.find_by_user_id_and_post_id(vote_params[:user_id], vote_params[:post_id])
    if !@user.nil? and !@vote.nil? and @user.id==vote_params[:user_id] and @vote.user_id==@user.id and @vote.update_attributes(vote_params)
      @result = true
    else
      @result = false
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :post_id, :up)
  end
end