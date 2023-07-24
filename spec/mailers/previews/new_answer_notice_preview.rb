class NewAnswerNoticePreview < ActionMailer::Preview
  def notice
    NewAnswerNoticeMailer.notice(User.first, Answer.first)
  end
end
