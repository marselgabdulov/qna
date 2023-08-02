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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
