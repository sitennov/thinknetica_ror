source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'responders', '~> 2.0'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-turbolinks'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'slim-rails'
gem 'bootstrap-sass'
gem 'devise'
gem 'simple_form'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'skim'
gem 'gon'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'whenever'
gem 'sidekiq'
gem 'sidetiq'
gem 'redis-rails'
gem 'sinatra', '>= 1.3.0', require: nil

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'letter_opener'
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'faker'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'json_spec'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
