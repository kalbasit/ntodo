###
#
# This file is part of nTodo
# 
# Copyright (c) 2009 Wael Nasreddine <wael.nasreddine@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, 
# USA.
#
###

require 'rubygems'
require 'dm-core'
require 'dm-validations'

module Ntodo

  class Database
	@@db = nil

	def initialize
	  if @@db.nil?
		# Get the configuration.
		config = Ntodo::Configuration.configuration

		raise ArgumentError unless config.is_a?(Hash)

		#adapter = Sequel::Database::ADAPTERS.detect {|db| db.to_s.eql? config[:adapter]}

		# TODO: Add proper exception
		#raise ArgumentError if adapter.nil? || adapter.empty?

		# Form the database.
		db = config[:adapter] << ':'
		if config[:db_user]
		  db << config[:db_user]
		  db << ':'
		  db << config[:db_passwd]
		  db << '@'
		  db << config[:db_hostname]
		  db << '/'
		end
		db << config[:database]

		@@db = DataMapper.setup(:default, db)
	  end
	end

	def db
	  @@db
	end

	def migrate
	  DataMapper.auto_migrate!
	end

  end
end