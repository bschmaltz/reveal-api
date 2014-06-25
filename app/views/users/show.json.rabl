object @user
attributes :id, :username, :created_at

if !@user.nil?
  node(:avatar_medium) {@user.avatar.url(:medium) }
end
