collection @users
attributes :id, :username, :created_at

node :avatar_thumb do |user|
  user.avatar.url(:thumb)
end