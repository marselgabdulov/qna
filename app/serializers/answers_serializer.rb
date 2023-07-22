class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :best, :rating, :created_at, :updated_at, :short_body

  belongs_to :user
  belongs_to :question

  def short_body
    object.body.truncate(20)
  end
end
