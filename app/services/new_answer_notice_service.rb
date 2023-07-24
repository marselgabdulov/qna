class NewAnswerNoticeService
  def self.send_notice(answer)
    answer.question.subscriptions.each do |sub|
      NewAnswerNoticeMailer.notice(sub.user, answer).deliver_later
    end
  end
end
