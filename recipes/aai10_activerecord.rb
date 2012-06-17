if config['database']
  say_wizard "Configuring '#{config['database']}' database settings..."
  old_gem = gem_for_database
  @options = @options.dup.merge(:database => config['database'])
  gsub_file 'Gemfile', "gem '#{old_gem}'", "gem '#{gem_for_database}'"
  template "config/databases/#{@options[:database]}.yml", "config/database.yml.new"
  run 'mv config/database.yml.new config/database.yml'
  unless config['username'].blank?
    gsub_file "config/database.yml", /username:(.*)$/, "username: #{config['username']}"
  end
  unless config['password'].blank?
    gsub_file "config/database.yml", /password:(.*)$/, "password: #{config['password']}"
  end
end

after_bundler do
  rake "db:create" if config['auto_create']
end

__END__

name: aai10_activerecord
description: "Use the default ActiveRecord database store."
author: aai10
exclusive: orm
category: persistence
tags: [sql, defaults, orm]

config:
  - database:
      type: multiple_choice
      prompt: "Which database are you using?"
      choices:
        - ["MySQL", mysql]
        - ["Oracle", oracle]
        - ["PostgreSQL", postgresql]
        - ["SQLite", sqlite3]
  - auto_create:
      type: boolean
      prompt: "Automatically create database with default configuration?"
  - username:
      type: string
      prompt: "Database username:"
  - password:
      type: string
      prompt: "Database password:"
