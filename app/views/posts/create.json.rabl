object @post
attributes :id, :content, :watch_stat, :ignore_stat, :created_at, :updated_at

if @result==true
  node(:success) { true }

  if @post.revealed==true
    node(:user_id) { @post.user_id }
    node(:username) { @post.user.username }
  else
    node(:user_id) { 0 }
    node(:username) { "Anonymous" }
  end
else
  node(:success) { false }
end