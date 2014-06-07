class Session < ActiveRecord::Base
  attr_accessor :username, :password, :match

  belongs_to :user

  before_validation :authenticate_user

  validates_presence_of :match,
    :message => 'for your username and password could not be found',
    :unless => :session_has_been_associated?

  before_save :associate_session_to_user

  private

  def authenticate_user
    unless session_has_been_associated?
      self.match = User.find_by_username_and_password(self.username, self.password)
    end
  end

  def associate_session_to_user
    self.user_id ||= self.match.id
  end

  def session_has_been_associated?
    self.user_id
  end
end
