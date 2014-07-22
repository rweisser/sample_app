require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do
    let(:user) { create_new_user }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_correct_title_for ('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { create_new_users 30 }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }
  
      describe "as an admin user" do
        let(:admin) { create_new_admin }
        before do
          sign_in admin
          visit users_path
        end
  
        it { should have_link('delete', href: user_path(User.first)) }
  
        # The following three tests are the same.  The second and third
        # use custom matchers.
  
        it "should be able to delete another user (1)" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
  
        # Doesn't work yet:
        # it "should be able to delete another user (2)" do
        #   expect('delete').to destroy(User, match: :first)
        # end
  
        it "should be able to delete another user (3)" do
          expect('delete').to destroy_first(User)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { create_new_user }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_correct_title_for(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_correct_title_for('Sign up') }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      # Replaced by custom matcher below.
      # it "should not create a user" do
      #   expect { click_button submit }.not_to change(User, :count)
      # end

      it "should not create a user" do
        expect(submit).not_to create(User)
      end

      # NOT USED: See creation_expectations.rb
      # it { should_not create(User) }

      describe "after submission" do
        before { click_button submit }

        it { should have_correct_title_for("Sign up") }
        it { should have_error_message("error") }
        it { should have_content("Name can't be blank") }
        it { should have_content("Email can't be blank") }
        it { should have_content("Email is invalid") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Password is too short (minimum is " +
                                 "6 characters") }
      end
    end

    describe "with valid information" do
      before { fill_in_signup_form_correctly }

      # Replaced by custom matcher below.
      # it "should create a user" do
      #   expect { click_button submit }.to change(User, :count).by(1)
      # end

      it "should create a user" do
        expect(submit).to create(User)
      end

      # NOT USED: See creation_expectations.rb
      # it { should create(User) }

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_correct_title_for(user.name) }
        it { should have_success_message('Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { create_new_user }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_correct_title_for("Edit user") }
      it { should have_link("change", href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
      it { should have_error_message('error') }
    end

    describe "with_valid_information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_correct_title_for(new_name) }
      it { should have_success_message('Profile updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to   eq new_name }
      specify { expect(user.reload.email).to  eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin:                 true,
                  password:              user.password,
                  password_confirmation: user.password } }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
