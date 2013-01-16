require 'bundler/setup'
Bundler.require

require 'real_estate'

class SearchApp < Sinatra::Base
  set :public_folder, "#{File.dirname(__FILE__)}/static"

  get '/' do
    slim :index, layout: false
  end

  post '/search' do
    json = MultiJson.load params[:json]

    input = json.inject({}) do |hash, item|
      key, value = item.first
      hash[key.to_sym] = value
      hash
    end

    results = RealEstate.search do |pf|
      pf.query do |q|
        if city = input[:city]
          q.string "city:#{city}" if city
        end
      end

      if rooms = input[:rooms]
        pf.filter :term, rooms: rooms
      end

      range = {from: input[:from], to: input[:to]}
      if range.values.find(&:present?)
        pf.filter :range, price: range
      end
    end

    MultiJson.dump results
  end
end