collection @items
attributes :id, :item_type, :content, :revealed, :watch_stat, :ignore_stat, :current_user_vote, :created_at, :updated_at, :vote_id, :followed_username, :followed_user_id


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
    "https://s3.amazonaws.com/reveal-api-assets/static_assets/default_avatars/thumb/anonymous.jpg"
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

node :current_user_is_poster do |post|
  if post.nil? or @user.nil?
    false
  else
    post.user_id==@user.id
  end
end
