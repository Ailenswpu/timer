source "https://gems.ruby-china.org"

ruby "2.3.1"

gem "rails", "5.0.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc
gem "ffi"
gem 'puma'


group :production do
  gem "pg"
  # gem "mysql2"
end

group :development do
  gem "bullet"
  gem "pry-rails"
  gem "rubocop", require: false
end

group :test do
  gem "simplecov", require: false
  gem "coveralls", require: false
end

group :development, :test do
  gem "byebug"
  gem "factory_girl_rails"
  gem "minitest-rails-capybara"
  gem "minitest-reporters"
  gem "mocha", require: "mocha/api"
  gem "newrelic_rpm"
  gem "spring"
  gem "sqlite3"
  gem "timecop"
  gem "web-console", "~> 2.0"

  gem 'capistrano'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano3-monit', github: 'naps62/capistrano3-monit'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

end

gem "ruby-enum"
gem "kaminari"
gem "mailgun-ruby", "~> 1.0.3", require: "mailgun"
gem "unicorn"
gem "pushover"
gem "sidekiq"
gem "simple_form"
gem "sinatra", require: nil
gem "twitter-bootstrap-rails"
