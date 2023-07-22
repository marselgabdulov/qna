require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:votable_class) { create(model.to_s.underscore.to_sym) }

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end
end
