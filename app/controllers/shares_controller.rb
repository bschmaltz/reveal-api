class SharesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @share = Share.new(share_params)
    @post = Post.find(share_params[:post_id])
    if !@user.nil? and !@post.nil? and @post.user_id!=share_params[:user_id] and @user.id==share_params[:user_id] and @share.save
      @result = true
    else
      @result = false
    end
  end

  def destroy
    @user = authenticate_token
    @share = Share.find_by_user_id_and_post_id(params[:user_id], params[:post_id])
    if !@user.nil? and !@share.nil? and @share.user_id==@user.id and @share.destroy
      @result = true
    else
      @result = false
    end
  end

  private

  def share_params
    params.require(:share).permit(:user_id, :post_id)
  end
end
