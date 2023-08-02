class Answer < ApplicationRecord
  include Attachable
  include Authorable
  include Linkable
  include Votable
  include Commentable

  belongs_to :question, touch: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  after_commit :send_notice, on: :create

  def mark_as_best
		transaction do
			self.class.where(question_id: self.question_id).update_all(best: false)
      question.reward&.update!(user_id: user_id)
			update(best: true)
		end
	end

  private

  def send_notice
    NewAnswerNoticeJob.perform_later(self)
  end
end
