def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    # I had to add the next line to try to make the tests for Ex. 9.6.6 work.
    # Otherwise, signed_in? returns false.
    # The line exists in # app/helpers/sessions_helper.rb,
    # although it was qualified by "self.".
    # Unfortunately, it didn't work.  I'm not sure what self is here.
    # self.current_user = user
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

def create_new_user(options = {})
  FactoryGirl.create(:user, options)
end

def create_new_users(n)
  n.times { create_new_user }
end

def create_new_admin(options = {})
  FactoryGirl.create(:admin, options)
end

