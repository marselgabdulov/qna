class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :best, :rating, :created_at, :updated_at

  belongs_to :user
  has_many :links
  has_many :comments
end
