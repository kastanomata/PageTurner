module SessionsHelper
  def logged_in?
    !Current.user.nil?
  end
end
