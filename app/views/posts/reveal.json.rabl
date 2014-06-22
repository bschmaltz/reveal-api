object @post

if @result==false
  node(:success) { false }
else
  node(:user_id) { @post.user_id }
  node(:username) { @post.user.username }
  node(:avatar_thumb) { @post.user.avatar.url(:thumb) }
  node(:success) { true }
end