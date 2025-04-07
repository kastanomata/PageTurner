class ErrorsController < ApplicationController
  allow_unauthenticated_access

  def unauthorized
    render status: :unauthorized # Renders with HTTP 401 status
  end
end
