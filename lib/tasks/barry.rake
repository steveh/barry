require 'rubygems'
require 'nokogiri'
require 'lib/barry/datamapper'

namespace :barry do

  desc 'Re-scan your iTunes music library'
  task :rescan do
    DataMapper.auto_migrate!

    path = "/Users/#{ENV['USER']}/Music/iTunes/iTunes Music Library.xml"

    doc = Nokogiri::XML(File.open(path, 'r'))

    # Find each dictionary item and loop through it
    doc.xpath('/plist/dict/dict/dict').each do |node|
      hash     = {}
      last_key = nil

      # Stuff the key value pairs in to hash.  We know a key is followed by
      # a value, so we'll just skip blank nodes, save the key, then when we
      # find the value, add it to the hash
      node.children.each do |child|
        next if child.blank? # Don't care about blank nodes
        if child.name == 'key'
          # Save off the key
          last_key = child.text
        else
          # Use the key we saved
          hash[last_key] = child.text
        end
      end

      Track.create({
        :sort_artist => hash['Sort Artist'],
        :sample_rate => hash['Sample Rate'],
        :kind => hash['Kind'],
        :name => hash['Name'],
        :file_folder_count => hash['File Folder Count'],
        :location => hash['Location'],
        :bit_rate => hash['Bit Rate'],
        :size => hash['Size'],
        :library_folder_count => hash['Library Folder Count'],
        :track_type => hash['Track Type'],
        :track_count => hash['Track Count'],
        :album => hash['Album'],
        :album_artist => hash['Album Artist'],
        :genre => hash['Genre'],
        :track_id => hash['Track ID'],
        :persistent_id => hash['Persistent ID'],
        :date_added => hash['Date Added'],
        :date_modified => hash['Date Modified'],
        :artist => hash['Artist'],
        :sort_album_artist => hash['Sort Album Artist'],
        :release_date => hash['Release Date'],
        :year => hash['Year'],
        :total_time => hash['Total Time'],
        :track_number => hash['Track Number'],
      })
    end
  end

end