module ApplicationHelper
  def hide_button_for(resource)
    current_user&.voted_for?(resource) ? 'hidden' : ''
  end

  def show_button_for(resource)
    current_user&.voted_for?(resource) ? '' : 'hidden'
  end

  def hide_sub_button_for(resource)
    current_user&.subscribed?(resource) ? 'hidden' : ''
  end

  def show_sub_button_for(resource)
    current_user&.subscribed?(resource) ? '' : 'hidden'
  end
end
