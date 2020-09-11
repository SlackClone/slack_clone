# Load the Rails application.
require_relative 'application'
VALID_LANG= ["en", "zh-TW"]
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
# Initialize the Rails application.
Rails.application.initialize!
