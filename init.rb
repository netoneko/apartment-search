require 'bundler/setup'
Bundler.require

require 'real_estate'

Tire.configure do
  if searchbox_url = ENV['SEARCHBOX_URL']
    url searchbox_url
  end
end