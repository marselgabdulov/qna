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

  def creation_time(resource)
    resource.created_at.to_s(:short)
  end

  def time_ago(resourse_created_at)
    "#{distance_of_time_in_words(Time.now, resourse_created_at)} ago"
  end
end
