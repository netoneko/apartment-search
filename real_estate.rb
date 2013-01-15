class RealEstate
  include Tire::Model::Persistence
  include Tire::Model::Search

  %w(title description owner phone city rooms price address lat long).each do |name|
    property name.to_sym
  end
end