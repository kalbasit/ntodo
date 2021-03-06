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

	# Run the operation
	# * The operation could be an add/delete or list
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

	# Add a project or a task
	def add
	  if not (@operation[:task].nil? || @operation[:project].nil?)
		add_task
	  elsif not @operation[:project].nil?
		add_project
	  else
		raise ArgumentError, "With the add operation, you should specify either a project or a task."
	  end
	end

	# Add a task
	def add_task
	  if @operation[:task][:description].nil?
		puts "Please enter the description of the new task"
		require 'readline'
		description = ""
		while line = Readline.readline('> ', true)
		  description << line
		end
	  else
		description = @operation[:task][:description]
	  end

	  # Fetch project
	  project = Project.first(:name => @operation[:project])
	  raise ArgumentError, "The project #{@operation[:project]} does not exist." if project.nil?

	  task = project.tasks.new
	  task.title = @operation[:task][:title]
	  task.description = description

	  unless task.save
		task.errors.each do |e|
		  puts e
		end
		raise ArgumentError, "Sql errors, can't proceed"
	  end
	end

	# Add a project
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
	  if @operation[:project].nil?
		list_projects
	  else
		list_tasks
	  end
	end

	def list_projects
	  puts "Here's the project list"
	  Project.all.each do |project|
		puts "\t" +  project.name
	  end
	end

	def list_tasks
	  begin
		tasks = Project.all(:name => @operation[:project]).tasks
		raise ArgumentError if tasks.empty?

		puts "Here's the task list of the project #{@operation[:project]}"
		puts

		tasks.each do |task|
		  task_desc = '#' + task.in_project_id.to_s + "\t" + task.title + "\t" + task.description
		  puts task_desc
		end
	  rescue
		puts "The project does not exist or it doesn't have any tasks"
		exit 1
	  end
	end
  end
end