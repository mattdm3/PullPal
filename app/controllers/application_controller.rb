class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  def current_user
    Rails.logger.debug "Session[:user_id]: #{session[:user_id]}"
    @current_user ||= User.find_by(id: session[:user_id])
    Rails.logger.debug "Current user: #{@current_user.inspect}"
    @current_user
  end

  def logged_in
    !current_user.nil?
  end
end
