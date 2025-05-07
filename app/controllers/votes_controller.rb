# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  before_action :find_poll_and_club

  def create
    return unless member_of_club?

    unless @poll.active?
      redirect_to club_path(@club), alert: "Voting has ended for this poll"
      return
    end

    @vote = Current.user.votes.new(
      poll: @poll,
      poll_option: PollOption.find(params[:poll_option_id])
    )

    if @vote.save
      redirect_to club_path(@club), notice: "Vote recorded!" # CORRECTED
    else
      redirect_to club_path(@club), alert: @vote.errors.full_messages.to_sentence # CORRECTED
    end
  end

  private

  def find_poll_and_club
    @poll = Poll.find(params[:id])
    @club = @poll.club
  end

  def member_of_club?
    return true if @club.is_member?(Current.user)

    redirect_to club_path(@club), alert: "Only club members can vote"
    false
  end
end
