# Replacements for

# expect page.to have_selector(html_spec, text: message)

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-notice', text: message)
  end
end

