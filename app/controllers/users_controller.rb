# typed: true

class UsersController < ApplicationController
  extend T::Sig
  before_action :set_user

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    if @user.authenticate(params[:current_password])
      if @user.update(password: params[:new_password], password_confirmation: params[:password_confirmation])
        redirect_to edit_user_path, notice: "Password updated successfully."
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Current password is incorrect"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username)
  end
end
