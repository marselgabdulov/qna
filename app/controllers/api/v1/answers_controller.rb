class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers, each_serializer: AnswersSerializer
  end
end
