class ApplicationController < ActionController::Base
  skip_before_filter  :verify_authenticity_token
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper :all # include all helpers, all the time

  before_filter :maintain_session_and_user

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3ef815416f775098fe977004015c6193'

  def ensure_login
    unless @authenticated_user
      #Please login to continue
      redirect_to(new_session_path)
    end
  end

  def ensure_logout
    if @authenticated_user
      #You must logout before you can login or register
      redirect_to(root_url)
    end
  end

  private

  def maintain_session_and_user
    if session[:id]
      if @application_session = Session.find_by_id(session[:id])
        @application_session.update_attributes(
          :ip_address => request.remote_addr,
          :path => request.path_info
        )
        @authenticated_user = @application_session.user
      else
        session[:id] = nil
        redirect_to(root_url)
      end
    end
  end
end
