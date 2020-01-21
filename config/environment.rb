require_relative '../tinyGameEngine/UI.rb'
require_relative '../tinyGameEngine/gameevent.rb'
require_relative '../tinyGameEngine/gametrigger.rb'
require 'bundler'
Bundler.require


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
