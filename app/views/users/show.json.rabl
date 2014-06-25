object @user
attributes :id, :username, :created_at

node :avatar_medium do |user|
  if user.nil?
    ""
  else
    user.avatar.url(:medium)
  end
end
