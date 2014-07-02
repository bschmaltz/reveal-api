object @user
attributes :id, :username, :created_at

node(:current_user_follows) { @current_user_follows }
node(:follower_stat) { @follower_stat }
node(:followed_stat) { @followed_stat }

node :avatar_medium do |user|
  if user.nil?
    ""
  else
    user.avatar.url(:medium)
  end
end
