class RevealNotificationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    @old_notifications = nil
    @new_notifications = nil
    user = authenticate_token
    if !user.nil?
      @old_notifications = RevealNotification.where("user_id = ? AND viewed = ?", user.id, true)
      @new_notifications = RevealNotification.where("user_id = ? AND viewed = ?", user.id, false)
    end
  end

  def viewed_new_notifications
    @result = false
    user = authenticate_token
    if !user.nil?
      @new_notifications = RevealNotification.where("user_id = ? AND viewed = ?", user.id, false)

      if @new_notifications.update_all(viewed: true)
        @result=true
      end
    end
  end

  def destroy
    user = authenticate_token
    notification = RevealNotification.find_by_user_id_and_post_id(params[:user_id], params[:post_id])
    if !user.nil? and !notification.nil? and notification.destroy
      @result = true
    else
      @result = false
    end
  end
end
