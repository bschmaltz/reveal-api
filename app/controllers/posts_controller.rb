class PostsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @post = Post.new(post_params)
    @post.username = User.find(post_params[:user_id]).username
    if !@user.nil? and @user.id==post_params[:user_id] and @post.save
      @result = true
    else
      @result = false
    end
  end

  def index
    @posts = nil
    if params[:last_post_id].nil?
      @posts = Post.order(created_at: :desc).limit(10)
    else
      last_post = Post.find(params[:last_post_id].to_i)
      @posts = Post.where("created_at <= :last_post_date AND id != :last_post_id",{last_post_date: last_post.created_at, last_post_id: last_post.id}).order(created_at: :desc).limit(10)
    end

    @user = authenticate_token
    @posts_with_votes = []

    #\33t h6x
    @posts.each do |post|
      if @user.nil?
         @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: 'no vote', vote_stat: post.vote_stat})))
      else
        vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
        if @user.id == post.user_id
          @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: 'up', vote_stat: post.vote_stat})))
        elsif vote.nil?
          @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: 'no vote', vote_stat: post.vote_stat})))
        elsif vote.up
          @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: 'up', vote_stat: post.vote_stat})))
        else
          @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: 'down', vote_stat: post.vote_stat})))
        end
      end
    end
  end

  def show
    @user = authenticate_token
    @post = Post.find(params[:id])
    if @user.nil?
      @current_user_vote = 'no vote'
    else
      vote = Vote.find_by_user_id_and_post_id(@user.id, params[:id])
      if @user.id == @post.user_id
        @current_user_vote = 'up'
      elsif vote.nil?
        @current_user_vote = 'no vote'
      elsif vote.up
        @current_user_vote = 'up'
      else
        @current_user_vote = 'down'
      end
    end
  end

  def update
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==post_params[:user_id] and @user.id==@post.user_id and @post.update_attributes(post_params)
      @result = true
    else
      @result = false
    end
  end

  def destroy
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.destroy
      @result = true
    else
      @result = false
    end
  end

  def reveal
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.update_attribute(:revealed, true)
      @result = true
    else
      @result = false
    end
  end

  def hide
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.update_attribute(:revealed, false)
      @result = true
    else
      @result = false
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :revealed)
  end
end
