class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sing_up_path_for(resource)
    root_path
  end
end
