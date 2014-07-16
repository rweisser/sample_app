# Replacement for
#
# expect(page).to have_title(full_title(suffix))
#
# Usage:
#
# expect(page).to     have_correct_title_for(suffix)
# expect(page).not_to have_correct_title_for(suffix)

RSpec::Matchers.define :have_correct_title_for do |suffix|
  match do |page|
    page.has_title?(full_title(suffix))

    # To make it fail:
    # page.has_title?(full_title(suffix) + 'x')
  end

  failure_message_for_should do |page|
    "page does not have title #{full_title(suffix)}"
  end

  failure_message_for_should_not do |page|
    "page should not have title #{full_title(suffix)}"
  end
end

