collection @items
attributes :id, :item_type, :share_id, :share_username, :share_user_id, :content, :revealed, :vote_stat, :current_user_vote, :share_stat, :current_user_shared, :created_at, :updated_at

node :current_user_is_poster do |post|
  if post.nil? or @user.nil?
    false
  else
    post.user_id==@user.id
  end
end

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
