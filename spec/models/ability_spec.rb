require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:question) { create(:question, user: user) }
    let(:another_answer) { create(:answer, user: another_user) }
    let(:another_question) { create(:question, user: another_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'subscriptions' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, Subscription }
    end
  end
end
