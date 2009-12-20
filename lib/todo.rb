###
#
# This file is part of todo
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

# stdlib

# internal requires
require 'todo/ui'
require 'todo/db'
require 'todo/recap'
require 'todo/task'

module Todo

  def self.configuration
	config_file = File.join(ENV['HOME'], *%w[.config todo config.yml])

	begin
	  config = YAML.load_file(config_file)
	  raise "Invalid configuration - #{config_file}" unless config.is_a?(Hash)
	  STDOUT.puts "Configuration loaded from #{config_file}"
	rescue => err
	  STDERR.puts "Configuration cannot be read from the config file, perhaps I couldn't parse it."
	  STDERR.puts "\t" + err.to_s
	  exit 1
	end

	config
  end

  def self.version
	yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
	"#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end