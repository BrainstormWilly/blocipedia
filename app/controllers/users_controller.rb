class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      if @user.member?
        Wiki.publicize_user_wikis(@user)
      end
      flash[:notice] = 'User was updated successfully'
      redirect_to @user
    else
      flash.now[:alert] = 'There was an error saving the user. Please try again later.'
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

end
