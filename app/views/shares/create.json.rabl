object @share
attributes :post_id

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end