class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery prepend: true, with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_unauthorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:name, :email, :password) }
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    welcome_index_path
  end

  def user_unauthorized
    flash[:alert] = "You are not authorized to do this."
    redirect_to(request.referrer || root_path)
  end

end
