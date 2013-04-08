task :environment do
  require './init'
end

namespace :db do
  desc "Clean up Elasticsearch"
  task :purge => :environment do
    RealEstate.find(:all).map &:destroy
  end

  desc "Populate Elasticsearch with data"
  task :seed => :environment do
    YAML.load_file("#{File.dirname(__FILE__)}/db.yml").each do |params|
      RealEstate.create params
    end
  end
end
