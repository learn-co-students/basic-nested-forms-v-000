class Person < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attributes_for :addresses

  def artist_attributes=(artist)
    self.artist = Artist.find_or_create_by(name: artist.name)
    self.artist.update(artist)
  end
end
