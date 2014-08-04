# Replacements for
#
# expect { click_button element }.to     change(model, :count).by(1)
# expect { click_button element }.not_to change(model, :count)
# expect { click_button element }.not_to change(model, :count).by(-1)
#
# and similar examples using click_link instead of click_button
#
# model can be, e. g. User.
#
# Usage:
#
# expect(text).to     create(model)
# expect(text).not_to create(model)
#
# expect(text).to     destroy(model)
# expect(text).not_to destroy(model)
#
# where text is the name of a button or link
#
# Example:
#
# expect('submit').to create(User)
# expect('delete').to destroy(User)

RSpec::Matchers.define :create do | model, options |
  match do | element |
    count = model.count
    click element, options
    model.count == count + 1
  end
end

RSpec::Matchers.define :destroy do | model, options |
  match do | element |
    count = model.count
    click element, options
    model.count == count - 1
  end
end

RSpec::Matchers.define :destroy_first do | model, options |
  match do | element |
    count = model.count
    click element, (options ||= {}).merge(match: :first)
    model.count == count - 1
  end
end

# First tries to click a button.  If there is no button which
# matches element, tries to click a link.
def click(element, options)
  click_button element, options
rescue Capybara::ElementNotFound
  begin
    click_link element, options
  rescue Capybara::ElementNotFound
    error_msg = "No button or link found matching '#{element}'"
    raise ArgumentError, error_msg
  end
end

########################################
# Old stuff (didn't work)
########################################

# NOTE:  This stuff is NOT BEING USED.  I couldn't figure
# out how to change the matcher to a predicate, so I don't
# think it is correct to use it as a matcher.  All
# the messages (desciption and failure) are ignored,
# because the real test is inside the expect.  Since
# the test is #count, which needs to be called twice,

# I don't think it can be changed to a simple
# predicate.

# It did work, though, and it looked great in the tests.

# Examples:
#   it { should create(User) }  
#   it { should_not create(User) }  
#   it { should destroy(User) }  

# RSpec::Matchers.define :create do | model |
#   match do |page|
#     puts ''
#     puts 'In create'
#     expect { click_button submit }.to change(model, :count).by(1)
#   end
# 
#   description do
#     "create a new user"
#   end
# 
#   failure_message_for_should do |page|
#     "have created a new #{model}"
#   end
# 
#   failure_message_for_should_not do |page|
#     "not have created a new #{model}"
#   end
# end
# 
# RSpec::Matchers.define :destroy do | model |
#   match do |page|
#     expect { click_buttom submit }.to change(model, :count).by(-1)
#   end
# end
