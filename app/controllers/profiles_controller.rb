class ProfilesController < ApplicationController
  before_action :find_user,except:[:edit]
  before_action :find_profile,only:[:edit,:update]
  def show
    @profile = Profile.find_by(user_id: params[:id])
  end

  def edit
    render json: @profile
  end

  def update
    @profile = Profile.where(user_id: current_user.id).first_or_create
    @profile.update(profile_params)
  end
  
  private
  def find_user
    @user = User.find(params[:id])
  end
  def profile_params
    params.require(:profile).permit(:full_name, :avatar, :phone_number)
  end
  
  def find_profile
    @profile = Profile.find_by(user_id: current_user.id)
  end

end
