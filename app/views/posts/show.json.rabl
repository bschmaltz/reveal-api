object @post
attributes :id, :content, :revealed, :vote_stat, :created_at, :updated_at

node(:current_user_vote) { @current_user_vote }

node :current_user_is_poster do |post|
  if post.nil? or @user.nil?
    false
  else
    post.user_id==@user.id
  end
end

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
