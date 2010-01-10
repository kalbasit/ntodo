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

namespace :db do
  task :load_config => :environment do
    Sequel.extension :migration
    Sequel.extension :schema_dumper
  end

  namespace :schema do
    desc "drops the schema, using schema.rb"
    task :drop => [:load_config, :dump] do
      eval(File.read(File.join(NTODO_ROOT, 'db', 'schema.rb'))).apply(DB, :down)
    end

    desc "loads the schema from db/schema.rb"
    task :load => :load_config do
      eval(File.read(File.join(NTODO_ROOT, 'db', 'schema.rb'))).apply(DB, :up)
      latest_version = Sequel::Migrator.latest_migration_version(File.join(NTODO_ROOT, 'db', 'migrate'))
      Sequel::Migrator.set_current_migration_version(DB, latest_version)
      puts "Database schema loaded version #{latest_version}"
    end

    desc "Dumps the schema to db/schema.db"
    task :dump => :load_config do
      schema = DB.dump_schema_migration
      schema_file = File.open(File.join(NTODO_ROOT, 'db', 'schema.rb'), "w"){|f| f.write(schema)}
    end

    desc "Returns current schema version"
    task :version => :load_config do
      puts "Current Schema Version: #{Sequel::Migrator.get_current_migration_version(DB)}"
    end
  end

  desc "Migrate the database through scripts in db/migrate and update db/schema.rb by invoking db:schema:dump. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :load_config do
    Sequel::Migrator.apply(DB, File.join(NTODO_ROOT, 'db', 'migrate'))
    Rake::Task["db:schema:dump"].invoke
    Rake::Task["db:schema:version"].invoke
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :load_config do
      Rake::Task["db:rollback"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:schema:dump"].invoke
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :load_config do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      puts "migrating up to version #{version}"
      Sequel::Migrator.apply(DB, File.join(NTODO_ROOT, 'db', 'migrate'), version)
      Rake::Task["db:schema:dump"].invoke
	  Rake::Task["db:schema:version"].invoke
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :load_config do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      current_version = Sequel::Migrator.get_current_migration_version(DB)
      down_version = current_version - step
      down_version = 0 if down_version < 0
      puts "migrating down to version #{down_version}"
      Sequel::Migrator.apply(DB, File.join(NTODO_ROOT, 'db', 'migrate'), down_version)
      Rake::Task["db:schema:dump"].invoke
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :load_config do
    Rake::Task["db:migrate:down"].invoke
  end

  desc 'Drops and recreates the database from db/schema.rb for the current environment.'
  task :reset => ['db:schema:drop', 'db:schema:load']
end