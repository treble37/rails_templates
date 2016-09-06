gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0.1'

# # Use sqlite3 as the database for Active Record
#gem 'sqlite3'

gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'httparty'
gem "haml-rails"
gem 'annotate'
gem 'figaro'
gem 'pundit'
gem 'lol_dba', require: false
gem 'foreman'
gem 'newrelic_rpm'


gem_group :development do
  gem 'sextant'
  gem 'awesome_print', require: false
  gem 'hirb', require: false
  gem 'bullet'
  # gem 'unicorn'
  gem 'flog', require: false #code complexity smell
  gem 'flay', require: false #code duplication 
  gem 'reek', require: false #code smells
  gem 'derailed'
  gem 'stackprof'
  gem 'sandi_meter'
  gem 'rubocop', require: false
end

gem_group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'pry'
end

gem_group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "codeclimate-test-reporter", require: nil
  gem 'shoulda-matchers', require: false
end

gem_group :production, :staging do
  gem 'rails_12factor'
  gem 'puma'
end

inside 'config/environments' do
  insert_into_file 'development.rb', %Q{
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end},
  after: "# since you don't have to restart the web server when you make code changes."
end

inside 'config' do
  insert_into_file 'application.rb', %Q{
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end},
  after: "# config.i18n.default_locale = :de"
end

generate('haml:application_layout', 'convert')
generate('rspec:install')

run "rm app/views/layouts/application.html.erb"
run "rm -rf test"
run "mkdir spec/support"
run "touch spec/support/database_cleaner.rb"

inside'spec/support' do
  insert_into_file 'database_cleaner.rb', %Q{
  RSpec.configure do |config|

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end
  }, after: ""
end

gsub_file "app/assets/javascripts/application.js", /^\/\/= require turbolinks$/,''
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

