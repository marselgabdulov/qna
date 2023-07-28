class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment, only: :destroy

  def destroy
    authorize! :destroy, @attachment
    @attachment.purge
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
