task :environment do
  require "bundler/setup"
  Bundler.require

  require 'real_estate'
end

namespace :db do
  desc "Populate Elasticsearch with data"
  task :seed => :environment do
    RealEstate.find(:all).map &:destroy

    YAML.load_file("#{File.dirname(__FILE__)}/db.yml").each do |params|
      RealEstate.create params
    end
  end
end