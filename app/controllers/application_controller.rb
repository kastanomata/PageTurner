class ApplicationController < ActionController::Base
  include Authentication

  # Remove or avoid any global authentication enforcement
  # allow_unauthenticated_access # Comment this out if present

  # Allow modern browsers (this is unrelated to authentication)
  allow_browser versions: :modern
end
