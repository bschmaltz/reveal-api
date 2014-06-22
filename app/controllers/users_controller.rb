class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @result = true
    else
      @result = false
    end
  end

  def update
    @user = authenticate_token
    if !@user.nil? and @user.id==params[:id].to_i and @user.update_attributes(user_params)
      @result = true
    else
      @result = false
    end
  end

  def update_avatar
    @user = authenticate_token
    new_avatar = nil
    if @user.nil? or (params[:avatar].nil? and params[:remote_url].empty?)
      @result = false
    else
      if !params[:avatar].nil? 
        new_avatar = params[:avatar]
      else
        new_avatar = URI.parse(params[:remote_url])
      end
      if @user.update_attribute(:avatar, new_avatar)
        @result = true
      else
        @result = false
      end
    end
    
    render 'update'
  end

  def destroy
    @user = authenticate_token
    @user_del = User.find(params[:id])
    if !@user.nil? and @user.id==@user_del.id and @user_del.destroy
      @result = true
    else
      @result = false
    end
  end

  def login
    @user = User.find_by_username_and_password(user_params[:username], user_params[:password])
    if @user.nil?
      @result = false
    else
      @result = true
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :avatar)
  end
end
