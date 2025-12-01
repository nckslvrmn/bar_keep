# typed: true

class Admin::UsersController < ApplicationController
  extend T::Sig

  before_action :require_admin
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :toggle_admin ]

  def index
    @users = User.all.order(:username)
  end

  def show
    @items_count = @user.items.count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.except(:user_type))
    set_user_type(@user, params[:user][:user_type])

    if @user.save
      redirect_to admin_users_path, notice: "User #{@user.username} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    user_type = params[:user][:user_type]

    if @user.update(user_params.except(:user_type))
      set_user_type(@user, user_type) if user_type.present?
      redirect_to admin_users_path, notice: "User #{@user.username} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot delete your own account."
      return
    end

    if @user.admin? && User.admins.count == 1
      redirect_to admin_users_path, alert: "Cannot delete the last admin user."
      return
    end

    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  def toggle_admin
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot change your own admin status."
      return
    end

    if @user.admin? && User.admins.count == 1
      redirect_to admin_users_path, alert: "Cannot remove admin status from the last admin user."
      return
    end

    @user.update(is_admin: !@user.is_admin)
    status = @user.admin? ? "granted admin privileges" : "removed from admin role"
    redirect_to admin_users_path, notice: "User #{@user.username} has been #{status}."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :user_type)
  end

  def set_user_type(user, type)
    user.is_admin = false
    user.is_guest = false

    case type
    when "admin"
      user.is_admin = true
    when "guest"
      user.is_guest = true
    end

    user.save
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You must be an admin to access this page."
      redirect_to root_path
    end
  end
end
