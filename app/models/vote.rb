class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :user_id, :value, :votable_id, presence: true
end
