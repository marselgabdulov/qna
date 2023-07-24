class NewAnswerNoticeMailer < ApplicationMailer
  def notice(user, answer)
    @answer = answer

    mail to: user.email
  end
end
