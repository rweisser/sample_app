# Replacement for
#
# expect(page).to have_selector('h1', text: heading)
#
# Usage:
#
# expect(page).to     have_heading1(heading)
# expect(page).not_to have_heading1(heading)

RSpec::Matchers.define :have_heading1 do |heading|
  match do |page|
    page.has_selector?('h1', text: heading)

    # To make it fail:
    # page.has_selector?('h1', text: heading + 'x')
  end
  
  # description and the failure messages did not work.
  # rspec seems to be generating the description from
  # have_selector('h1', text: heading).   I also tried
  # putting description in the match block.
  #
  # Update:  After I took the expect out of the matcher, and
  # replaced it with an equivalent boolean, everything started
  # to work.

  description { "have h1 heading \"#{heading}\"" }

  failure_message_for_should do |page|
    "page should have had h1 heading \"#{heading}\""
  end

  failure_message_for_should_not do |page|
    "page should not have had h1 heading \"#{heading}\""
  end
end
