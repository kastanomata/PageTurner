class ApplicationController < ActionController::Base
  include Authentication
  include LoggingUtility

  # Remove or avoid any global authentication enforcement
  # allow_unauthenticated_access # Comment this out if present

  # Allow modern browsers (this is unrelated to authentication)
  allow_browser versions: :modern
  before_action :check_nickname

  private

  def check_nickname
    if authenticated? && Current.user&.nickname.nil?
      ("User #{Current.user.id} has no nickname set.")
      redirect_to "/users/#{Current.user&.id}/edit"
    end
  end
end
