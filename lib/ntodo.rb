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

$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# rubygems
require 'rubygems'

# core
require 'fileutils'
require 'time'
require 'yaml'
require 'pp'

# stdlib

# internal requires
require 'ntodo/config'
require 'ntodo/db'
require 'ntodo/models'
require 'ntodo/operations'
require 'ntodo/path'
require 'ntodo/recap'
require 'ntodo/task'
require 'ntodo/ui'
require 'ntodo/version'

module Ntodo
  class Bootstrap
	def initialize(options)
	  options = {} if options.nil?

	  if options.nil? || options.empty?
		options[:ui] = :ncurses if options[:ui].nil?
	  else
		options[:ui] = :cli if options[:ui].nil?
	  end

	  @@options = options

	  # Connect to the database
	  database = Ntodo::Database.new

	  # Make sure our database is up to date.
	  DataMapper.auto_upgrade!
	end

	def execute
	  raise ArgumentError, "No operations were specified." if @@options[:ui] == :cli && (@@options[:operation].nil? || @@options[:operation].empty?)

	  if @@options[:ui] == :cli
		operation = Ntodo::Operations.new @@options[:operation]
		operation.run
	  else
		# Run the ncurses interface
	  end
	end

	def self.options
	  @@options
	end
  end
end