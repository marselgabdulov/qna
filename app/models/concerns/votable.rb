module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def create_vote_up(user)
    votes.find_or_create_by(user: user, value: 1)
  end

  def create_vote_down(user)
    votes.find_or_create_by(user: user, value: -1)
  end

  def make_revote(user)
    votes.find_by(user: user)&.destroy
  end
end
