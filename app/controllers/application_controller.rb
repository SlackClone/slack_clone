class ApplicationController < ActionController::Base
  before_action :set_locale
  helper_method :has_avatar?
  def set_locale
    # 可以將 ["en", "zh-TW"] 設定為 VALID_LANG 放到 config/environment.rb 中
    if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def after_sign_in_path_for(resource)
    workspace_channel_path(session[:workspace_id], session[:channel]) if session[:workspace_id] && session[:channel]
    root_path
  end
end
