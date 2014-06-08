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
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
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