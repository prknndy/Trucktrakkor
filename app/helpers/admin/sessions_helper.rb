module Admin::SessionsHelper
  
  def sign_in(user)
    cookies.signed[ :remember_token] = { :value => [user.email, user.salt], :expires => 60.minutes.from_now }
    @current_user=user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def sign_out
    cookies.delete( :remember_token)
    current_user = nil
  end
  
  def authenticate
    deny unless signed_in?
  end
  
  def deny
    redirect_to root_url
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
  
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
