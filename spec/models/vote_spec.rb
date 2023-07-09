require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'authorable'

  describe 'associations' do
    it { should belong_to(:votable) }
  end

  describe 'validations' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :votable_id }
  end
end
