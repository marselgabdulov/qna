class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  after_action :publish_answer, only: [:create]

  include Voted

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    @answer.mark_as_best
    @question = @answer.question
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    ActionCable.server.broadcast 'answers', @answer unless @answer.errors.any?
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
