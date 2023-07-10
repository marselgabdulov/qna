class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :load_question, only: %i(show edit update destroy publish_question)
  after_action :publish_question, only: [:create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.build_reward
    @question.votes.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      flash[:notice] = 'The question was successfully destroyed.'
      redirect_to questions_path
    else
      redirect_to @question, notice: 'Only an author can do it.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    ActionCable.server.broadcast 'questions', @question unless @question.errors.any?
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy], reward_attributes: %i[id name image _destroy])
  end
end
