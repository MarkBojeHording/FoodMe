class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def index
    @feedbacks = Feedback.all
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to root_path, notice: 'Thank you for your feedback!'
    else
      render :new
    end
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_path, notice: 'Delete successful'
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :comment, :feedback_date)
  end
end
