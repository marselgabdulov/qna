require 'rails_helper'

RSpec.describe NewAnswerNoticeMailer, type: :mailer do
  describe 'notice' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NewAnswerNoticeMailer.notice(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notice')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("New answer for question: #{answer.question.title}!")
    end
  end
end
