require 'bundler/setup'
Bundler.require

class SearchApp < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/' do
    slim :index, layout: false
  end

  run! if app_file == $0
end