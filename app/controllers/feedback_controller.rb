class FeedbackController < ApplicationController
  before_filter :require_user

  def index
    @feedback = Feedback.new
  end

  def send_feedback
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = current_user.id
    if @feedback.save
      Notifier.feedback(@feedback).deliver
      redirect_to profile_path, notice: 'Thank you for your feedback!'
    else
      render :index
    end
  end

  def feedback_params
    params.require(:feedback).permit(:category, :comment)
  end
end