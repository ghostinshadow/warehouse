require 'capybara/poltergeist'
Capybara.asset_host = 'http://localhost:3000'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false})
end
Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :poltergeist