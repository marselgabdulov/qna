class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :user_id, :title, :body, :created_at, :updated_at, :files_url

  belongs_to :user
  has_many :links
  has_many :comments
  has_many :answers

  def files_url
    object.files.map { |file| { url: rails_blob_url(file, only_path: true) } }
  end
end
