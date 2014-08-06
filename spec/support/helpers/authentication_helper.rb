module AuthenticationHelper

  def sign_in(user, options={})
    if options[:no_capybara]
      # Sign in when not using Capybara.
      remember_token = User.new_remember_token
      cookies[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.digest(remember_token))
    else
      visit signin_path
      valid_signin(user)
    end
  end
  
  def valid_signin(user)
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
  
  def fill_in_signup_form_correctly
    fill_in "Name",             with: "Example User"
    fill_in "Email",            with: "user@example.com"
    fill_in "Password",         with: "foobar"
    fill_in "Confirm Password", with: "foobar"
  end
  
  def create_user(options = {})
    FactoryGirl.create(:user, options)
  end
  
  def create_users(n, options = {})
    n.times { create_user options}
  end
  
  def create_admin(options = {})
    FactoryGirl.create(:admin, options)
  end

  def create_micropost(options = {})
    FactoryGirl.create(:micropost, options)
  end
end
