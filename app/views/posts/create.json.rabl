object @post
attributes :id, :content, :created_at, :updated_at

if @result==true
  node(:success) { true }

  if @post.revealed==true
    node(:username) { @post.username }
  else
    node(:username) { "Anonymous" }
  end
else
  node(:success) { false }
end