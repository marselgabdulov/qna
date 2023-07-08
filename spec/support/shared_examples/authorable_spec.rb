require 'rails_helper'

shared_examples_for 'authorable' do
  describe 'associations' do
    it { should belong_to(:user) }
  end
end
