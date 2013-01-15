require 'bundler/setup'
Bundler.require

class SearchApp < Sinatra::Base
  get '/' do
    'hi'
  end

  run! if app_file == $0
end