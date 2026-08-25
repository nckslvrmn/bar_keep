module ApplicationHelper
  FLASH_ALERT_CLASSES = {
    "notice" => "alert-success",
    "success" => "alert-success",
    "alert" => "alert-danger",
    "error" => "alert-danger",
    "warning" => "alert-warning"
  }.freeze

  def flash_alert_class(type)
    FLASH_ALERT_CLASSES.fetch(type.to_s, "alert-info")
  end
end
