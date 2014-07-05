object false

child @new_notifications => :new_notifications do
  collection @new_notifications
  attributes :id, :post_id, :user_id, :viewed
  
  node :post_avatar do |notification|
    notification.post.user.avatar.url(:thumb)
  end
  node :post_user_id do |notification|
    notification.post.user.id
  end
  node :post_username do |notification|
    notification.post.user.username
  end
  node :post_content do |notification|
    notification.post.content
  end
end

child @old_notifications => :old_notifications do
  collection @old_notifications
  attributes :id, :post_id, :user_id, :viewed
  
  node :post_avatar do |notification|
    notification.post.user.avatar.url(:thumb)
  end
  node :post_user_id do |notification|
    notification.post.user.id
  end
  node :post_username do |notification|
    notification.post.user.username
  end
  node :post_content do |notification|
    notification.post.content
  end
end