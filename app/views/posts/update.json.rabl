object @post

extends "posts/show"

if @result==false
  node(:success) { false }
else
  node(:success) { true }
end