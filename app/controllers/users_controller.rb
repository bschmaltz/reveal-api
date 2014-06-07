class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :ensure_login, :only => [:edit, :update, :destroy]
  before_filter :ensure_logout, :only => [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @session = @user.sessions.create
      session[:id] = @session.id
    end
  end

  def edit
    @user = User.find(@authenticated_user)
  end

  def update
    @user = User.find(@authenticated_user)
    if @user.update_attributes(user_params)
      @result = true
    else
      @result = false
    end
  end

  def destroy
    @result = User.destroy(@authenticated_user)
    session[:id] = @authenticated_user
  end

  private

   def user_params
    params.require(:user).permit(:username, :password)
  end
end
