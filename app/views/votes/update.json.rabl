object @vote
attributes :post_id, :action

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end