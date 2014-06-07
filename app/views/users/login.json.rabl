object @user
attributes :id, :username, :auth_token

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end
