module ApplicationHelper
  def hide_button_for(resource)
    current_user&.voted_for?(resource) ? 'hidden' : ''
  end

  def show_button_for(resource)
    current_user&.voted_for?(resource) ? '' : 'hidden'
  end
end
