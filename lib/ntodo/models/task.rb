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

class Task
  include DataMapper::Resource

  # Relations
  belongs_to :project
  has n, :logs

  # Properties
  property :id,					Serial
  property :project_id,			Integer, :unique => true, :key => true
  property :title,				String
  property :description,		Text
  property :created_on,			DateTime
  property :updated_at,			DateTime

  # Validations
  validates_present :project_id
  validates_present :title
  validates_present :description
end