RSpec::Matchers.define :have_heading1 do |heading|
  match do |page|
    expect(page).to have_selector('h1', text: heading)
  end
  
  # description did not work.  rspec seems to be generating
  # the description from have_selector('h1', text: heading)
  # I also tried putting description in the match block.
  description { "have highest level heaing #{heading}" }

  failure_message_for_should do |page|
    "page does not have title #{full_title(suffix)}"
  end

  failure_message_for_should_not do |page|
    "page should not have title #{full_title(suffix)}"
  end
end
