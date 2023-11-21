source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in messaging.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development do
  gem "guard"
  gem "guard-minitest"
  gem "guard-rubocop"
  gem "guard-reek"
  gem "standard", require: false
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

gem "devise"
