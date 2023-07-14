require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'authorable'

  describe 'associations' do
    it { should belong_to(:commentable) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :commentable_id }
  end
end
