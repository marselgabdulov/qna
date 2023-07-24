require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '#send_notice' do
    let(:answer) { build(:answer) }

    it 'calls NewAnswerNoticeJob' do
      expect(NewAnswerNoticeJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
