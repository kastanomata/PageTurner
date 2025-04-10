class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  skip_before_action :check_nickname, only: %i[ destroy ]

  def show
      redirect_to root_path
  end

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user, source: :password_login
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    puts "CURRENT ID:", Current.session.id
    terminate_session
    redirect_to root_path, notice: "You have been logged out."
  end
end
