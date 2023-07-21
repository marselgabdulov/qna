require 'rails_helper'

shared_examples_for 'linkable' do
  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
    it { should accept_nested_attributes_for :links }
  end
end
