require 'rubygems'
require 'sinatra/base'
require 'lib/barry/datamapper'
require 'json'
require 'uri'

class Barry < Sinatra::Base

  get '/' do
    'Barry is up and running.'
  end

  get '/api/browse/artists' do
    content_type 'text/javascript'

    artists = Track.artists

    artists.collect{ |a| artist_result(a) }.to_json
  end

  get '/api/browse/artists/:artist' do
    content_type 'text/javascript'

    albums = Track.albums(:artist => params[:artist])

    albums.collect{ |a| album_result(a) }.to_json
  end

  get '/api/browse/artists/:artist/:album' do
    content_type 'text/javascript'

    tracks = Track.tracks(:artist => params[:artist], :album => params[:album])

    tracks.collect{ |a| track_result(a) }.to_json
  end

  get '/api/browse/albums' do
    content_type 'text/javascript'

    albums = Track.albums()

    albums.collect{ |a| album_result(a) }.to_json
  end

  get '/api/browse/albums/:album' do
    content_type 'text/javascript'

    tracks = Track.tracks(:album => params[:album])

    tracks.collect{ |a| track_result(a) }.to_json
  end

  get '/api/search/:terms' do
    content_type 'text/javascript'

    tracks = Track.search(params[:terms])

    tracks.collect{ |a| track_result(a) }.to_json
  end

  get '/stream/:track_id' do
    track = Track.first(:track_id => params[:track_id])

    path = URI.unescape(track.location.gsub(/^file:\/\/localhost/, ''))

    send_file(path)
  end

  private

    def artist_result(a)
      { :artist_name => a[:album_artist], :num_tracks => a[:num_tracks] }
    end

    def album_result(a)
      { :artist_name => a[:album_artist], :album_name => a[:album], :num_tracks => a[:num_tracks] }
    end

    def track_result(a)
      { :artist_name => a[:artist], :album_name => a[:album], :track_id => a[:track_id], :track_name => a[:name], :track_number => a[:track_number], :year => a[:year], :total_time => a[:total_time] }
    end

end