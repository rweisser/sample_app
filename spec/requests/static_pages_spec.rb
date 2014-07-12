require 'spec_helper'

describe "Static pages" do

  # Note:  The tests for full_title are in
  # spec/helpers/application_helper_spec.rb.

  # spec/support/utilities includes the ApplicationHelper module,
  # which contains the full_title mehtods.

  # Everything in spec/support is available.
  # I suppose everything in spec/helpers is available, as well.

  subject { page }

  # NOTE: Shared Example
  shared_examples_for "all static pages" do
    it { should have_heading1(heading) }
    it { should have_correct_title_for(page_title) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_correct_title_for('About Us')
    click_link "Help"
    expect(page).to have_correct_title_for('Help')
    click_link "Contact"
    expect(page).to have_correct_title_for('Contact')
    click_link "Home"
    expect(page).to have_correct_title_for('')
    click_link "Sign up now!"
    expect(page).to have_correct_title_for('Sign up')
    click_link "sample app"
    expect(page).to have_correct_title_for('')
  end
end
