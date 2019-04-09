class ApplicationController < ActionController::Base
  include CartsHelper
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {redirect_to main_app.root_url, notice: exception.message}
      format.js {head :forbidden, content_type: "text/html"}
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
