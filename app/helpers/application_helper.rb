module ApplicationHelper
  def alert_class_for(flash_type)
    {
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-success"
    }[flash_type.to_sym] || flash_type.to_s
  end
end
