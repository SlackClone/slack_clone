class Users::ConfirmationsController < Devise::ConfirmationsController

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    new_workspace_path
  end
end
