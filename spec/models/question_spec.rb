require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'attachable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
