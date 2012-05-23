RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_title do |message|
	match do |page|
		page.should have_selector('title', text: message)
	end
end

RSpec::Matchers.define :have_header do |message|
	match do |page|
		page.should have_selector('h1', text: message)
	end
end
