object @result

if @result==false
  node(:success) { false }
else
  node(:success) { true }
end