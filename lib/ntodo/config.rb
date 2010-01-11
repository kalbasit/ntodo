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

# core
require 'fileutils'
require 'yaml'

module Ntodo
  CONFIG_FILE = File.join(ENV['HOME'], *%w[.config ntodo config.yml])

  class Configuration
	@@config = nil

	def self.configuration
	  if @@config.nil?
		begin
		  @@config = YAML.load_file(CONFIG_FILE)
		  raise "Invalid configuration - #{CONFIG_FILE}" unless @@config.is_a?(Hash)
		  STDOUT.puts "Configuration loaded from #{CONFIG_FILE}" if Ntodo::Bootstrap.options[:debug]
		rescue => err
		  STDERR.puts "Configuration cannot be read from the config file, perhaps I couldn't parse it."
		  STDERR.puts "\t" + err.to_s
		  exit 1
		end
	  end

	  @@config
	end
  end
end