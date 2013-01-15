require 'rack/coffee'
use Rack::Coffee, root: File.dirname(__FILE__), urls: '/'

require './search_app'
run SearchApp