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

module Ntodo
  def self.root
	File.expand_path(File.join(File.dirname(__FILE__), *%w[.. ..]))
  end

  def self.lib
	File.expand_path(File.join(Ntodo.root, 'lib'))
  end

  def self.bin
	File.expand_path(File.join(Ntodo.root, 'bin'))
  end
end