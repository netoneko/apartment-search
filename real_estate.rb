class RealEstate
  include Tire::Model::Persistence

  %w(title description author phone city rooms price address lat long).each do |name|
    property name.to_sym
  end
end