object @post

if @result==false
  node(:success) { false }
else
  node(:username) { @post.username }
  node(:success) { true }
end