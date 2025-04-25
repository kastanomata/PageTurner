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
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end

    def require_admin_access(**options)
      before_action -> { require_authentication("admin") }, **options
    end

    def current_user
      Current.user
    end
  end

  private
    def authenticated?
      resume_session
    end

    def admin?
      resume_session("admin")
    end

    def require_authentication(level = nil)
      resume_session(level) || request_authentication(level)
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
      # param-based lookup
      resource ||= find_resource_by_params

      # Handle missing resource
      unless resource
        redirect_to root_path, alert: "Resource not found."
        return
      end

      # Check ownership
      can_access_resource = current_user_owns?(resource) || Current.user.admin?
      debug can_access_resource
      unless can_access_resource
        redirect_to unauthorized_path
      end
    end

    def check_ban
      Current.session ||= find_session_by_cookie
      ban = User.find_by(id: Current.session[:user_id])&.active_ban unless Current.session.nil?
      return unless ban

      redirect_to banned_user_path, alert: "Banned: #{ban.reason}. #{ban.expires_at ? "Expires: #{ban.expires_at}" : 'Permanent'}"
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
