module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def raiting
    votes.sum(:value)
  end

  def vote_up(user)
    votes.find_or_create_by(user: user, value: 1)
  end

  def vote_down(user)
    votes.find_or_create_by(user: user, value: -1)
  end

  def revote(user)
    votes.find_by(user: user)&.destroy
  end
end
