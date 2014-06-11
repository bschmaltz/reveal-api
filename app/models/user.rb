require 'digest/sha2'

class User < ActiveRecord::Base
  attr_reader :password

  ENCRYPT = Digest::SHA256

  has_many :posts, dependent: :destroy
  has_many :votes
  has_many :user_followers, class_name: 'Follower', foreign_key: :user_id, dependent: :destroy
  has_many :user_followed, class_name: 'Follower', foreign_key: :followed_user_id, dependent: :destroy

  def followers
    user_followers+user_followed
  end

  validates_uniqueness_of :username, :case_sensitive => false, :message => "is already in use by another user"

  validates_format_of :username, :with => /\A([a-z0-9_]{2,16})\z/i,
    :message => "Username must be 4 to 16 letters, numbers or underscores and have no spaces"

  validates_format_of :password, :with => /\A([\x20-\x7E]){4,16}\z/,
    :message => "must be 4 to 16 characters",
    :unless => :password_is_not_being_updated?

  validates_confirmation_of :password
  before_create :set_auth_token
  before_save :scrub_username
  after_save :flush_passwords

  def self.find_by_username_and_password(username, password)
    user = self.find_by_username(username)
    if user and user.encrypted_password == ENCRYPT.hexdigest(password + user.salt)
      return user
    end
  end

  def password=(password)
    @password = password
    unless password_is_not_being_updated?
      self.salt = [Array.new(9){rand(256).chr}.join].pack('m').chomp
      self.encrypted_password = ENCRYPT.hexdigest(password + self.salt)
    end
  end

  private

  def scrub_username
    self.username.downcase!
  end

  def flush_passwords
    @password = @password_confirmation = nil
  end

  def password_is_not_being_updated?
    self.id and self.password.blank?
  end

  def set_auth_token
    return if auth_token.present?

    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: self.auth_token)
  end
end