class Post < ActiveRecord::Base
  after_initialize :default_values

  validates_length_of :content, :minimum => 1, :maximum => 200, :allow_blank => false


  private
  def default_values
    self.revealed ||= false
  end
end
