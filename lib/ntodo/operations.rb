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

module Ntodo
  class Operations
	def initialize(operations)
	  @operation = operations
	end

	def run
	  case @operation[:type]
	  when :add
		add
	  when :delete
		delete
	  when :list
		list
	  else
		raise ArgumentError, "I'm not aware of any operation of the type #{@operation[:type]}"
	  end
	end

	def add
	  if not (@operation[:task].nil? || @operation[:project].nil?)
		add_task
	  elsif not @operation[:project].nil?
		add_project
	  else
		raise ArgumentError, "With the add operation, you should specify either a project or a task."
	  end
	end

	def add_task
	  # Fetch project
	  project = Project.first(:name => @operation[:project])
	  raise ArgumentError, "The project #{@operation[:project]} does not exist." if project.nil?

	  task = Task.new
	  task.project_id = project.id
	  task.title = @operation[:task][:title]
	  task.description = @operation[:task][:description]

	  unless task.save
		task.errors.each do |e|
		  puts e
		end
		raise ArgumentError, "Sql errors, can't proceed"
	  end
	end

	def add_project
	  project = Project.new
	  project.attributes = { :name => @operation[:project] }
	  unless project.save
		project.errors.each do |e|
		  puts e
		end
		raise ArgumentError, "Sql errors, can't proceed"
	  end
	end

	def delete

	end

	def list
	end

  end
end