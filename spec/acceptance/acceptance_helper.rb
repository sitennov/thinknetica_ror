require 'rails_helper'

Capybara.server = :puma
Capybara.server_port = 4000

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.include WaitForAjax, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(
      :truncation,
      except: %w(ar_internal_metadata))
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
