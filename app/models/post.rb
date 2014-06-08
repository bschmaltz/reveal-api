class Post < ActiveRecord::Base
  belongs_to :user
  has_many :votes

  validates_length_of :content, :minimum => 1, :maximum => 200, :allow_blank => false
end
