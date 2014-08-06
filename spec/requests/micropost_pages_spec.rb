require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { create_user }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect('Post').not_to create(Micropost)
        # expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_error_message "error" }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect('Post').to create(Micropost)
      end
    end
  end

  describe "micropost destruction" do
    before { create_micropost user: user }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect('delete').to destroy(Micropost)
      end
    end
  end
end
