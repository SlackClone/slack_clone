class Application < Rails::Application
  config.i18n.load_path += Dir[Rails.root.join('config','locales', '**', '*.yml').to_s]
  config.i18n.available_locales = ["en", "zh-TW"]
  config.i18n.default_locale = "en"
  # use default locale when translation missing
  config.i18n.fallbacks = true
  
end
  