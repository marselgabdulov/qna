class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer = Answer.find(params[:id])
    question = @answer.question

    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'The answer was successfully destroyed.'
      redirect_to question
    else
      redirect_to question, notice: 'Only an author can do it.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
