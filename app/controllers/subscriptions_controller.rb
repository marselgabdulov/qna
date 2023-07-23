class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    current_user.subscriptions.find_or_create_by(question: @question)
  end

  def destroy
    @question = Question.find(params[:id])
    current_user.subscriptions.find_by(question: @question)&.destroy
  end
end
