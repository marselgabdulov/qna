require 'rails_helper'

RSpec.describe NewAnswerNoticeJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls NewAnswerNoticeService#send_notice' do
    expect(NewAnswerNoticeService).to receive(:send_notice).with(answer)
    NewAnswerNoticeJob.perform_now(answer)
  end
end
