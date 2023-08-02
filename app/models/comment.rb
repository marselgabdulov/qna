class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true, touch: true

  validates :user_id, :body, :commentable_id, presence: true
end
