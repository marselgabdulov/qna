class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    case @commentable
    when Question
      ActionCable.server.broadcast "question_#{@commentable.id}-comments", @comment
    when Answer
      ActionCable.server.broadcast "question_#{@commentable.question.id}-comments", @comment
    end
  end
end
