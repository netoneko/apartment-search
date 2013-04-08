require 'rack/coffee'
use Rack::Coffee, root: File.dirname(__FILE__), urls: '/'

require File.join(File.dirname(__FILE__), 'search_app')
run SearchApp
