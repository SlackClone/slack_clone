class ProfilesController < ApplicationController
  before_action :find_user,except:[:edit,:avatar_url]
  before_action :find_profile,only:[:edit,:update,:destroy,:avatar_url]

  def show
    @profile = Profile.find_by(user_id: params[:id])
  end

  def edit
    return render json: {user:{ nickname: current_user.nickname}} if @profile == nil
    render json: @profile.as_json(include: {user: {only: :nickname}})
  end

  def update
    @profile = Profile.find_or_create_by(user_id: current_user.id)
    @profile.update(profile_params)
    current_user.update(nickname: params[:user][:nickname])
    avatar_derivatives
    render file: "app/javascript/packs/reset_profile.js"
  end

  def avatar_url
    render json: {small: @profile.avatar_url(:small),medium: @profile.avatar_url(:medium),large: @profile.avatar_url(:large),user_id: current_user.id }
  end

  def destroy
    @profile.update(avatar_data: nil)
  end
  
  def update_avatar
    avatar_derivatives
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

  def avatar_derivatives
    if params['details']!= ""
      crop = JSON.parse(params["details"])
      @profile.avatar_derivatives!(crop: {x:crop["x"],y:crop["y"],w:crop["width"],h:crop["height"]}) if @profile.avatar_data? # create derivatives
      @profile.save
    end
  end
end
