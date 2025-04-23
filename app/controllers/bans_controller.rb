# app/controllers/bans_controller.rb
class BansController < ApplicationController
  require_admin_access
  skip_before_action :require_ownership

  def new
    @user = User.find(params[:user_id])
    @ban = Ban.new
  end

  def create
    @user = User.find(params[:user_id])
    @ban = @user.bans.new(ban_params.merge(moderator: Current.user))

    if @ban.save
      redirect_to @user, notice: "User banned."
    else
      render :new
    end
  end

  def destroy
    @ban = Ban.find(params[:id])
    @ban.update!(expires_at: Time.current)
    redirect_to @ban.user, notice: "User unbanned."
  end

  private

  def ban_params
    params.require(:ban).permit(:reason, :expires_at)
  end

  def authorize_moderator!
    authorize Ban
  end
end
