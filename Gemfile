source 'https://rubygems.org'

ruby '1.9.3', engine: 'jruby', engine_version: '1.7.2' # Heroku deployment

gem 'sinatra'
gem 'slim'

if RUBY_PLATFORM == 'java'
  gem 'therubyrhino'
else
  gem 'therubyracer'
end

gem 'coffee-script'
gem 'rack-coffee'

gem 'tire'
gem 'puma'

group :test do
  gem 'rspec'
  gem 'rack-test'
end