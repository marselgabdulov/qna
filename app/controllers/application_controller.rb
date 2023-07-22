class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to new_user_session_path, alert: exception.message }
      format.json { render json: { errors: exception.message }, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
