class AnswersController < ApplicationController
  expose :answer
  expose :question

  def create
    @exposed_answer = question.answers.new(answer_params)

    if answer.save
      redirect_to answer_path(answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
