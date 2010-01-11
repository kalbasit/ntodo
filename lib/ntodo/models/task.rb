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
  property :title,				String,		:required => true
  property :description,		Text,		:required => true
  property :created_on,			DateTime,	:required => true
  property :updated_at,			DateTime

  # Before calling valid, set the created_on
  before :valid?, :set_created_on

  # Before saving the changes to the database log it
  #before :save, :load_log
  #after :save, :save_log

  # Prepare the log
  def load_log(context = :default)
	log = []
	self.dirty_attributes.each do |dp, dv|
	  self.original_attributes.each do |op, ov|
		if op.model == dp.model && op.name == dp.name
		  ov = "nil" if ov.nil?
		  log << "The property #{dp.name} in the model #{dp.model} have changed from #{ov} to #{dv}"
		end
	  end
	end
  end

  # Save the log
  def save_log(context = :default)
	log_entry = Log.new
	log_entry.project_id = self.project_id
	log_entry.task_id = self.id
	log_entry.p1 = @log
	unless log_entry.save
	  log_entry.errors.each do |e|
		puts e
	  end
	  raise ArgumentError, "Sql error"
	end
  end

  # Set the created_on
  def set_created_on(context = :default)
	self.created_on = Time.now
  end
end