class Answer < ApplicationRecord
  include Attachable
  include Linkable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
		transaction do
			self.class.where(question_id: self.question_id).update_all(best: false)
      question.reward&.update!(user_id: user_id)
			update(best: true)
		end
	end
end
