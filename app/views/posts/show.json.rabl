object @post
attributes :id, :content, :revealed, :created_at, :updated_at

node :username do |post|
  if post.nil?
    ""
  elsif post.revealed
    post.username
  else
    "Anonymous"
  end
end
