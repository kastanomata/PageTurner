module Authentication
  include LoggingUtility
  include OwnershipUtility
  extend ActiveSupport::Concern

  included do
    before_action :check_ban
    before_action :require_authentication
    before_action :require_ownership, if: :ownership_required?
    helper_method :authenticated?
    helper_method :admin?
    helper_method :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end

    def require_admin_access(**options)
      before_action -> { require_authentication("admin") }, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def admin?
      resume_session("admin")
    end

    def current_user
      Current.user
    end

    def require_authentication(level = nil)
      return true if resume_session(level)

      request_authentication(level)
      false
    end

    def ownership_required?
      %w[edit update destroy].include?(action_name)
    end

    def find_resource_by_params
      model = controller_name.classify.safe_constantize
      return unless model && params[:id]

      begin
        model.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def require_ownership
      resource ||= find_resource_by_params
      unless resource
        redirect_to root_path, alert: "Resource not found."
        return
      end

      unless current_user_owns?(resource) || Current.user&.admin?
        redirect_to unauthorized_path
      end
    end

    def check_ban
      Current.session ||= find_session_by_cookie
      return unless Current.session

      ban = Current.session.user&.active_ban
      return unless ban

      redirect_to banned_user_path, alert: "Banned: #{ban.reason}. #{ban.expires_at ? "Expires: #{ban.expires_at}" : 'Permanent'}"
    end

    def resume_session(level = nil)
      Current.session ||= find_session_by_cookie
      return false unless Current.session

      Current.user = Current.session.user
      return false unless Current.user

      if level == "admin"
        Current.user.admin?
      else
        true
      end
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication(level)
      session[:return_to_after_authenticating] = request.url

      if level == "admin"
        render template: "errors/unauthorized", status: :unauthorized
      else
        redirect_to login_path
      end
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user, source: nil)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip, source:).tap do |session|
        Current.session = session
        Current.user = user
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Session.delete(Current.session.id) if Current.session
      Current.session = nil
      Current.user = nil
      cookies.delete(:session_id)
    end
end
