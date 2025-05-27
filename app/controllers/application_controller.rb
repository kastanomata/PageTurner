class ApplicationController < ActionController::Base
  include Authentication

  # Allow modern browsers (this is unrelated to authentication)
  allow_browser versions: :modern
  before_action :check_nickname
  skip_before_action :verify_authenticity_token

  private

  def check_nickname
    # info "CHECKING NICKNAME FOR ACTION: #{action_name}"
    if authenticated? && Current.user&.nickname.nil?
      ("User #{Current.user.id} has no nickname set.")
      redirect_to "/users/#{Current.user&.id}/edit"
    end
  end
end
