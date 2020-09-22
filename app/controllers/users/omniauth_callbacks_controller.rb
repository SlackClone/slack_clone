class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2

    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'].except('extra'), current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      if (cookies[:accept] && session[:token])
        sign_in @user, :event => :authentication
        Workspace.find(cookies[:accept]).users << @user
        Invitation.find_by(invitation_token: session[:token]).touch(:accept_at)
        redirect_to workspace_path(cookies[:accept])
      else
        sign_in @user, :event => :authentication
        return redirect_to workspaces_path
      end
    else
      session["devise.google_data"] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url
    end
    cookies.delete :accept
  end

  def failure
    redirect_to root_path, alert: "無法獲得驗證！"
  end

end