require 'rails_helper'

shared_examples_for 'linkable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:linkable_class) { create(model.to_s.underscore.to_sym) }

  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
    it { should accept_nested_attributes_for :links }
  end
end
