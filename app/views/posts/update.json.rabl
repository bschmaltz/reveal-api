object @post
attributes :id, :content, :revealed, :vote_stat, :created_at, :updated_at

node :username do |post|
  if post.user.nil?
    ""
  elsif post.revealed
    post.user.username
  else
    "Anonymous"
  end
end

node :avatar_thumb do |post|
  if post.user.nil?
    ""
  elsif post.revealed
    post.user.avatar.url(:thumb)
  else
    "/assets/default_avatars/thumb/anonymous.jpg"
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

if @result==false
  node(:success) { false }
else
  node(:success) { true }
end