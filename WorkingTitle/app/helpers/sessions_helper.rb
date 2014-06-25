module SessionsHelper
  def current_user
    if session[:current_user_id]
      @current_user ||= User.find_by_id(session[:current_user_id])
      return @current_user
    end
  end

  def logged_in?
    !current_user.nil?
  end
end
