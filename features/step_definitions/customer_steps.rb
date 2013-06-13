Given /^I am on the "(.*?)" auth page$/ do |page|
	Factory(:company)
	Factory(:country)
	Factory(:branch)
	Factory(:service)

  visit page
  click_link 'Sign in with Facebook'
end

When /^I am logged in facebook with login and password/ do
  fill_in "email", :with => Settings.facebook.user.login
  fill_in "pass", :with => Settings.facebook.user.password

  click_on "Войти"

  if page.has_css?("body.platform_dialog")
  	click_on "Перейти к приложению"
  end
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_selector('h2', :content => "Select a Service")
end
