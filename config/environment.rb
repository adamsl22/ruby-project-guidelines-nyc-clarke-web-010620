
require 'bundler'
Bundler.require

require_relative '../tinyGameEngine/UI.rb'
require_relative '../tinyGameEngine/gameevent.rb'
require_relative '../tinyGameEngine/gametrigger.rb'
require_relative '../tinyGameEngine/selectionmenu.rb'
require_relative '../tinyGameEngine/selectonemenu.rb'


require_relative'../app/models/dragon.rb'
require_relative'../app/models/raid_pairing.rb'
require_relative'../app/models/raid.rb'
require_relative'../app/models/village.rb'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/Dragon_Maker.db')
require_all 'lib'

DB = {:conn => SQLite3::Database.new("Dragon_Maker.db")}