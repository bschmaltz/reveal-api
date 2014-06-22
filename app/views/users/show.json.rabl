object @user
attributes :id, :username, :created_at

node(:avatar_medium) {@user.avatar.url(:medium) }