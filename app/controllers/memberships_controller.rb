class MembershipsController < ApplicationController
  def create
    user = User.find(Current.user.id)
    club = Club.find(params[:club_id])
    club.becomes_member(user)
    respond_to do |format|
      format.html { redirect_to club }
      format.js
    end
  end

  def destroy
    user = User.find(Current.user.id)
    club = Club.find(params[:club_id])
    club.unsubscribes(user)
    respond_to do |format|
      format.html { redirect_to club }
      format.js
    end
  end
end
