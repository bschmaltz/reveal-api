object @result

if @result==false
  node(:success) { false }
  note(:avatar_thumb) { 'http://s3.amazonaws.com/reveal-api-assets/static_assets/default_avatars/thumb/anonymous.jpg' }
else
  node(:success) { true }
end