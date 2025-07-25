# typed: false

class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]
  protect_from_forgery with: :reset_session, only: [ :create ], prepend: true

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(username: params[:username]&.downcase&.strip)

    if user&.authenticate(params[:password])
      login_user(user)
      redirect_to root_path, notice: "Welcome back, #{user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout_user
    redirect_to login_path, notice: "You have been logged out."
  end
end
