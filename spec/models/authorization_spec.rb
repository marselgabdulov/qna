require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user).required }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  subject { create(:authorization) }
  it { should validate_uniqueness_of(:provider).scoped_to(:uid).ignoring_case_sensitivity }
end
