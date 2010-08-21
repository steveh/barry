require 'dm-core'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, 'sqlite:db/barry.sqlite3')

require 'lib/barry/track'

DataMapper.finalize