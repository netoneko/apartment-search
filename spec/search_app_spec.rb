require 'search_app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

Bundler.require :test
set :environment, :test

describe 'The Apartment Search App' do
  include Rack::Test::Methods

  def app
    SearchApp
  end

  it "main page returns code 200" do
    get '/'
    last_response.should be_ok
  end

  it "CoffeeScript at least compiles" do
    root = "#{File.dirname(__FILE__)}/.."

    Dir.new(root).entries.grep(/coffee/).each do |script|
      CoffeeScript.compile File.read("#{root}/#{script}")
    end
  end
end