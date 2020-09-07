class Users::RegistrationsController < Devise::RegistrationsController
  
  private

  def after_inactive_sign_up_path_for(resource)
    super(resource)
    pages_path
  end

end
