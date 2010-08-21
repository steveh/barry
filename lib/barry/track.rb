class Track
  include DataMapper::Resource

  property :sort_artist, String
  property :sample_rate, Integer
  property :kind, String
  property :name, String
  property :file_folder_count, Integer
  property :location, Text
  property :bit_rate, Integer
  property :size, Integer
  property :library_folder_count, Integer
  property :track_type, String
  property :track_count, Integer
  property :album, String
  property :album_artist, String
  property :genre, String
  property :track_id, Integer, :key => true
  property :persistent_id, String
  property :date_added, DateTime
  property :date_modified, DateTime
  property :artist, String
  property :sort_album_artist, String
  property :release_date, DateTime
  property :year, Integer
  property :total_time, Integer
  property :track_number, Integer

  def self.artists(params = {})
    sql = "SELECT
	sort_album_artist,
	album_artist,
	COUNT(*) num_tracks
FROM tracks
GROUP BY album_artist
ORDER BY sort_album_artist COLLATE NOCASE"

    repository(:default).adapter.select(sql)
  end

  def self.albums(params = {})
    if params[:artist]
      where = "WHERE artist = '#{params[:artist]}'"
    else
      where = ""
    end

    sql = "SELECT
	album_artist,
	album,
	COUNT(*) num_tracks
FROM tracks
#{where}
GROUP BY album
ORDER BY album COLLATE NOCASE"

    repository(:default).adapter.select(sql)
  end

  def self.tracks(params = {})
    if params[:artist] && params[:album]
      where = "WHERE artist = '#{params[:artist]}' AND album = '#{params[:album]}'"
    elsif params[:artist]
      where = "WHERE artist = '#{params[:artist]}'"
    elsif params[:album]
      where = "WHERE album = '#{params[:album]}'"
    else
      where = ""
    end

    sql = "SELECT
	*
FROM tracks
#{where}
ORDER BY sort_album_artist, album, track_number"

    repository(:default).adapter.select(sql)
  end

  def self.search(terms)
    where = "WHERE artist LIKE '%#{terms}%' OR album LIKE '%#{terms}%' OR name LIKE '%#{terms}%'"

    sql = "SELECT
	*
FROM tracks
#{where}
ORDER BY sort_album_artist, album, name"

    repository(:default).adapter.select(sql)
  end
end