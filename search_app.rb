require_relative 'init'

class SearchApp < Sinatra::Base
  set :public_folder, "#{File.dirname(__FILE__)}/static"

  get '/' do
    slim :index, layout: false
  end

  post '/search' do
    json = MultiJson.load params[:json]

    input = json.inject({}) do |hash, item|
      key, value = item.first
      hash[key] = value
      hash
    end

    results = RealEstate.search do |pf|
      pf.query do |q|
        if city = input["city"]
          q.string "city:#{city}" if city
        end
      end

      if rooms = input["rooms"]
        pf.filter :term, rooms: rooms
      end

      range = {from: input["min price"], to: input["max price"]}
      if range.values.find(&:present?)
        pf.filter :range, price: range
      end
    end

    MultiJson.dump results
  end
end
