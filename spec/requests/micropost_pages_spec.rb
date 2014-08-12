require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { create_user }

  shared_examples_for "micropost pagination" do
    before do
      create_numbered_microposts 50, user: user, content: 'Test' 
      sign_in user
      visit path
    end

    it { should have_content(content) }

    it "should list each micropost" do
      Micropost.paginate(page: 1).each_with_index do | micropost, n |
        expect(page).to have_selector 'li', text: "#{50 - n}. Test"
      end
    end
  end

  describe "micropost creation" do
    before do
      sign_in user
      visit root_path
    end

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
    before do
      sign_in user
      create_micropost user: user 
    end

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect('delete').to destroy(Micropost)
      end
    end
  end

  describe "pagination" do

    describe "on the home page" do
      let(:content) { "50 microposts" }
      let(:path)    { root_path }

      it_should_behave_like "micropost pagination"
    end

    describe "on the user profile page" do
      let(:content) { "Microposts (50)" }
      let(:path)    { user_path user }

      it_should_behave_like "micropost pagination"
    end
  end
end

