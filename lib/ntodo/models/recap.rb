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

class Recap
  include DataMapper::Resource

  # Associations
  belongs_to  :project
  has n,	  :emails

  # Properties
  property :id,					Serial
  property :project_id,			Integer,	:required => true, :key => true
  property :email_id,			Integer,	:required => true, :key => true
  property :created_on,			DateTime,	:required => true

  # Before calling valid, set the created_on
  before :valid?, :set_created_on

  # Set the created_on
  def set_created_on (context = :default)
	self.created_on = Time.now
  end
end