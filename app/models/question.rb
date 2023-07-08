class Question < ApplicationRecord
  include Attachable
  include Linkable
  include Votable

  has_many :answers, dependent: :destroy

  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  belongs_to :user

  validates :title, :body, presence: true
end
