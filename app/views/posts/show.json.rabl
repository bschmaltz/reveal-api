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

node :user_id do |post|
  if post.nil?
    0
  elsif post.revealed
    post.user_id
  else
    0
  end
end
