class Song < ActiveRecord::Base
  # Keep in mind, too, that setter methods are useful
  # for more than just avoiding duplicates ––
  # that's just one domain where they come in handy.


  def artist_attributes=(artist)
    self.artist = Artist.find_or_create_by(name: artist.name)
    self.artist.update(artist)
  end
end
