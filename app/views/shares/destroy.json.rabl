object @result

if @result==true
  node(:success) { true }
else
  node(:success) { false }
end