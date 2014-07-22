# Replacements for
#
# expect { click_button button_text }.to     change(model, :count).by(1)
# expect { click_button button_text }.not_to change(model, :count)
#
# model can be, e. g. User.
#
# Usage:
#
# expect(button_text).to     create(model)
# expect(button_text).not_to create(model)
#
# expect(button_text).to     destroy(model)
# expect(button_text).not_to destroy(model)
#
# Example:
#
# expect(submit).to create(User)
#
# TODO: Alow the caller to pass text for a button or a link.

RSpec::Matchers.define :create do | model, options |
  match do | button |
    count = model.count
    click_button button, options
    model.count == count + 1
  end
end

RSpec::Matchers.define :destroy do | model, options |
  match do | button |
    count = model.count
    click_button button, options
    model.count == count - 1
  end
end

RSpec::Matchers.define :destroy_first do | model |
  match do | link |
    count = model.count
    click_link link, match: :first
    model.count == count - 1
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
