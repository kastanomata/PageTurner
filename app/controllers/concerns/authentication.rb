include LoggingUtility
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication(level = nil)
      # log_star("level " + level.to_s)
      resume_session(level) || request_authentication(level)
    end

    def resume_session(level = nil)
      if level == "admin"
        authenticated? and Current.session.user.admin?
      else
        Current.session ||= find_session_by_cookie
      end
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication(level)
      if level&.nil?
        session[:return_to_after_authenticating] = request.url
        redirect_to new_session_path
      elsif level == "admin"
        # log_star("not " + level.to_s)
        render template: "errors/unauthorized", status: :unauthorized
      end
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user, source: nil)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip, source:).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      puts "CURRENT ID:", Current.session.id
      Session.delete(id: Current.session.id)
      Current.session = nil
      cookies.delete(:session_id)
    end
end
