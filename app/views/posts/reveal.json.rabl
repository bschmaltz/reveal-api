object @post

if @result==false
  node(:success) { false }
else
  node(:user_id) { @post.user_id }
  node(:username) { @post.username }
  node(:success) { true }
end