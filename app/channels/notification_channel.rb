class NotificationChannel < ApplicationCable::Channel
  def subscribed
    user_notification = User.find(params[:id])
    stream_for user_notification
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
