class Post < ActiveRecord::Base
  validates_length_of :content, :minimum => 1, :maximum => 200, :allow_blank => false
end
