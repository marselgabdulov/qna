class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: 24.hours.ago..Time.current)

    mail to: user.email
  end
end
