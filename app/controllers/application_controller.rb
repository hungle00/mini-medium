class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?	
  
  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    case 
    when payload[:status] == 200
      payload[:level] = "INFO"
    when payload[:status] == 302
      payload[:level] = "WARN"
    else
      payload[:level] = "ERROR"
    end
  end

  protected
		
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :avatar, :remember_me]    
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    #devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end
end
