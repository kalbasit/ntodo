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
require 'sequel'

module Ntodo
  class Database
	attr_reader :db

	def initialize()
	  # Get the configuration.
	  config = Ntodo.configuration()

	  raise ArgumentError unless config.is_a?(Hash)

	  adapter = Sequel::Database::ADAPTERS.detect {|db| db.to_s.eql? config[:adapter]}

	  # TODO: Add proper exception
	  raise ArgumentError if adapter.nil? || adapter.empty?

	  @db = Sequel.connect(:adapter => adapter, :database => config[:database])
	end
  end
end