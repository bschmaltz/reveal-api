object @vote
attributes :post_id, :up

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end