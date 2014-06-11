object @follower
attributes :id, :user_id, :followed_user_id

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end
