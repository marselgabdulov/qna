class NewAnswerNoticeJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NewAnswerNoticeService.send_notice(answer)
  end
end
