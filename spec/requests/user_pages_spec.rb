require 'spec_helper'

describe "UserPages" do

  subject { page }

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
        it { should have_content("error") }
        it { should have_content("Name can't be blank") }
        it { should have_content("Email can't be blank") }
        it { should have_content("Email is invalid") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Password is too short (minimum is 6 characters") }
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
end
