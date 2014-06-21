class ApplicationController < ActionController::Base
  include ActionController::ImplicitRender
  include ActionController::MimeResponds

  def cors_preflight_check
    p "HIT OPTIONS CHECKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    headers['Access-Control-Max-Age'] = '1728000'

    render json: {} # Render as you need
  end

  protected
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.find_by(auth_token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end
end
