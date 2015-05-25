class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :active?

  def active?(a)
    return "class=\"is_active\"".html_safe if request.env['PATH_INFO'].start_with? a
    ''
  end
end
