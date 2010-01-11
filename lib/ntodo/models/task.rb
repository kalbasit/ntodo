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
  belongs_to	:project
  has n,		:logs

  # Properties
  property :id,					Serial
  property :project_id,			Integer,	:required => true, :key => true
  property :in_project_id,		Integer,	:required => true, :unique => true
  property :title,				String,		:required => true
  property :description,		Text,		:required => true
  property :created_on,			DateTime,	:required => true
  property :updated_at,			DateTime
  property :visible,			Boolean,	:default => true

  # Record the date/time this has been created if it's a new record
  before :valid?, :set_created_on

  # Record the date/time this has been updated if it's an old record
  before :valid?, :set_updated_on

  # Increment the in_project_id if it's a new record
  before :valid?, :increment_in_project_id

  # Increment the in_project id
  #
  # * This function will increment the in_project id which means we can
  # * have an in-project count without any extra effort outside the model
  def increment_in_project_id(context = :default)
	return unless attributes[:id].nil?

	tasks = Task.first(:order => [ :in_project_id.desc ])
	if tasks.nil? || tasks.in_project_id.nil?
	  self.in_project_id = 1
	else
	  self.in_project_id = tasks.in_project_id.to_i + 1
	end
  end

  # Set the created_on
  def set_created_on(context = :default)
	return unless attributes[:id].nil?

	self.created_on = Time.now
  end

  # Set the updated_on
  def set_updated_on(context = :default)
	return if attributes[:id].nil?

	self.updated_on = Time.now
  end

  # Get the visible tasks
  def self.visible(filter = {})
	filters = { :visible => true }
	filters.merge filter

	tasks = Task.all(filters)
  end
end