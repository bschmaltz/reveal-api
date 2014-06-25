object @post

if @result==false
  node(:success) { false }
else
  node(:success) { true }
  node(:avatar_thumb) { 'http://s3.amazonaws.com/reveal-api-assets/static_assets/default_avatars/thumb/anonymous.jpg' }
end