class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :ensure_login, :only => :destroy
  before_filter :ensure_logout, :only => [:new, :create]

  def index
    redirect_to(new_session_path)
  end

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)
    if @session.save
      session[:id] = @session.id
    else
      render(:action => 'new')
    end
  end

  def destroy
    @result = Session.destroy(@application_session)
    session[:id] = @user = nil
  end

  private

   def session_params
    params.require(:session).permit(:username, :password)
  end
end
