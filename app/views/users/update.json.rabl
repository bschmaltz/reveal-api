object @user
attributes :username

if @result==false
  node(:success) { false }
else
  node(:success) { true }
  node(:avatar_medium) {@user.avatar.url(:medium) }
end
