object @user
attributes :id, :username

if !@user.sessions.empty?
  node(:success) { true }
  node(:session_id) { @session.id }
else
  node(:success) { false }
end