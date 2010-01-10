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
  class Log < Sequel::Model
	many_to_one :project
	many_to_one :task

	def validate
	  errors.add(:project_id, "can't be empty") if project_id.empty?
	  errors.add(:task_id, "can't be empty") if task_id.empty?
	  errors.add(:type, "can't be empty") if type.empty?
	  errors.add(:written_on, "should be in the past") if written_on > Time.now
	end
  end
end