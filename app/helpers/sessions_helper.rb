module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    # update_attributes avoids validations.
    user.update_attribute(:remember_token, User.digest(remember_token))
    # puts "in sign_in, self = #{self}"
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    # logger.info "XXX before redirect, session[:return_to] = [#{session[:return_to]}]"
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
    # logger.info "XXX after delete, session[:return_to] = [#{session[:return_to]}]"
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
