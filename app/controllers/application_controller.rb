class ApplicationController < ActionController::Base
  layout 'two_column'

  protect_from_forgery

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    unless current_user.verified?
      current_user.verify
    else
      valid_email = ValidEmail.find_by_email(current_user.email)
      if valid_email && valid_email.checked_in? == false
        current_user.verify
      end
    end
    if current_user.staff?
      current_user.unit? ? unit_path(current_user.unit) : units_path
    elsif current_user.volunteer?
      units_path
    else
      user_path(current_user)
    end
  end

end
