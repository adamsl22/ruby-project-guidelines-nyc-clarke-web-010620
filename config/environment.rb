
require 'bundler'
Bundler.require

require_relative '../tinyGameEngine/UI.rb'
require_relative '../tinyGameEngine/gameevent.rb'
require_relative '../tinyGameEngine/gametrigger.rb'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
