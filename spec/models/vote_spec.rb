require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'authorable'

  it { should belong_to(:votable) }
end
