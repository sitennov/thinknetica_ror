module ApplicationHelper
  def alert_class_for(flash_type)
    {
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-success"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
