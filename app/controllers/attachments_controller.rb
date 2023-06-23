class AttachmentsController < ApplicationController
  def purge
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
  end
end
