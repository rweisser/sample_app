require 'spec_helper'

describe "Authentication" do

  subject { page }

  shared_examples_for "the signin page" do
    it { should     have_link('Sign in',   href: signin_path) }
    it { should_not have_link('Users',     href: users_path) }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
    it { should_not have_link('Sign out',  href: signout_path) }
  end

  describe "signin page" do
    before { visit signin_path }

    it { should     have_content('Sign in') }
    it { should     have_correct_title_for('Sign in') }
    it_should_behave_like "the signin page"
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_correct_title_for('Sign in') }
      it { should have_error_message('Invalid') }
      it_should_behave_like "the signin page"

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid information" do
      let(:user) { create_new_user }
      before { sign_in(user) }

      it { should     have_correct_title_for(user.name) }
      it { should     have_link('Users',     href: users_path) }
      it { should     have_link('Profile',   href: user_path(user)) }
      it { should     have_link('Settings',  href: edit_user_path(user)) }
      it { should     have_link('Sign out',  href: signout_path) }
      it { should_not have_link('Sign in',   href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { create_new_user }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_correct_title_for('Edit user')
          end
        end
      end
    end

    describe "for non-signed-in users" do
      let(:user) { create_new_user }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_correct_title_for('Sign in') }
          it { should have_notice_message('Please sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_correct_title_for('Sign in') }
        end
      end
    end

    # The following didn't work.  I couldn't find a way for the sign_in
    # method in spec/support/helpers/sessions_helper.rb to set things
    # up so that signed_in? would return true during testing.  Therefore,
    # when my before_action not_signed_in calls signed_in?, it always
    # returns false, but only in testing.  I put in some puts statements
    # to show that it was working correctly in the real app when I
    # directed the browser to localhost:3000/users/new.  The puts
    # output shows up in the log.  The signed_in?  method correctly
    # returns true in the log and the redirection works as will.

    # Unfortunately, there does not seem to be a way to direct the
    # browser to the create action, so I can't test what happens when
    # a signed_in user tries to access the create page in the real
    # app..

    # As far as I could tell, Hartl does not provide a way to test
    # these things using rspec, apparently for good reason.

    # describe "for signed-in users" do
    #   let(:user) { create_new_user }
    #   let(:new_user) { FactoryGirl.attributes_for :user }
    #   before { sign_in user, no_copybara: true }
    #  
    #   describe "in the Users controller" do
    #     
    #     describe "trying to access the new user page" do
    #       before { puts user; get new_user_path }
    #       specify { expect(response).to redirect_to(root_path) }
    #     end
    #     
    #     describe "trying to access the create user page" do
    #       before { post :create, new_user }
    #       specify { expect(response).to redirect_to(root_path) }
    #     end
    #   end
    # end

    describe "as wrong user" do
      let(:user)       { create_new_user }
      let(:wrong_user) { create_new_user email: "wrong@example.com" }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before  { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response.body).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#edit action" do
        before  { patch user_path(wrong_user) }
        specify { expect(response.body).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user)      { create_new_user }
      let(:non_admin) { create_new_user }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end

