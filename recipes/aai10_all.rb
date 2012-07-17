###MSIU GEMS
say_wizard "source gems.msiu.ru"
inject_into_file 'Gemfile', :after => "source 'https://rubygems.org'\n" do
  "source 'http://gems.msiu.ru'\n"
end


###DATABASE
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

###HAML
if config['haml']
  say_wizard 'haml'
  gem 'haml'
  gem 'haml-rails'
end


###BOOTSTRAP

gem 'twitter-bootstrap-rails', :group => :assets
# please install gem 'therubyracer' to use Less
gem 'therubyracer', :group => :assets, :platforms => :ruby


###CAS
gem 'rubycas-client-msiu', '>= 1.1'

###RSPEC
gem 'rspec', :group => [:development, :test]
gem 'rspec-rails', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]


###ERRBIT
if config['errbit']
  gem 'airbrake'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/config/initializers/errbit_example.rb', 'config/initializers/errbit.rb'
end


###LOCALE
gem 'russian'

###LOGINS
logins=config['logins'].split(/[\s,]+/)
if logins.any?
  append_file 'db/seeds.rb', logins.map { |l| "User.create(:login=>'#{l}')" }.join("\n")
end


after_bundler do

  ###DATABASE
  say_wizard "rake db:create"
  rake "db:create" if config['auto_create']

  ###RSPEC
  generate 'rspec:install'

  ###BOOTSTRAP
  say_wizard "bootstrap:install"
  generate 'bootstrap:install'
  layout_type=config['layout']
  extname= config['haml'] ? 'haml' : 'erb'
  remove_file 'app/views/layouts/application.html.erb'
  remove_file 'app/views/layouts/application.html.haml'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/helpers/basic_helper.rb', 'app/helpers/basic_helper.rb'
  gsub_file 'app/helpers/basic_helper.rb', /from\s*\=\s*2012/, "from = #{Time.now.year}"
  get "https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/views/layouts/application_#{layout_type}.html.#{extname}", "app/views/layouts/application.html.#{extname}"
  get "https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/views/layouts/_topbar.html.#{extname}", "app/views/layouts/_topbar.html.#{extname}"
  get "https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/views/layouts/_messages.html.#{extname}", "app/views/layouts/_messages.html.#{extname}"

  remove_file 'public/favicon.ico'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/images/favicon.ico', 'public/favicon.ico'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/images/logo.png', 'app/assets/images/logo.png'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/assets/stylesheets/basic.css', 'app/assets/stylesheets/basic.css'

  ###CAS
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/config/initializers/cas.rb', 'config/initializers/cas.rb'
  remove_file 'app/controllers/application_controller.rb'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/controllers/application_controller.rb', 'app/controllers/application_controller.rb'


  ###HOME PAGE
  say_wizard "Generate Home Page"

  remove_file 'public/index.html'
  remove_file 'public/rails.png'

  generate(:controller, "home index")

  remove_file "app/views/home/index.html.#{extname}"
  create_file "app/views/home/index.html.#{extname}" do
    if config['haml']
      "%h3 Home"
    else
      "<h3>Home</h3>"
    end
  end
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'


  ###LOCALE
  gsub_file 'config/application.rb', /# config.time_zone = 'Central Time \(US & Canada\)'/, '  config.time_zone = "Moscow"'
  create_file 'config/locales/ru.yml' do
<<-'YML'
ru:
  activerecord:
    models:
    attributes:
  YML
  end
end

after_everything do

  ###LOGINS
  unless logins.blank?
    generate 'model User login'
    rake 'db:migrate'
    rake 'db:seed'
  end

  ###GIT
  say_wizard "Git initialize"
  append_file '.gitignore',  "/.idea\n"
  append_file '.gitignore', "/.redcar\n"
  append_file '.gitignore', "/.nbproject\n"

  git :init
  git :add => '.'
  git :commit => "-aqm 'new Rails app generated by Rails Apps Composer gem'"
end

__END__

name: aai10_all
description: "Default MSIU Style."
author: aai10

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
  - layout:
      type: multiple_choice
      prompt: "Which layout type do you prefer?"
      choices: [["Fixed", fixed],["Fluid", fluid]]
  - errbit:
      type: boolean
      prompt: "User errbit exceptions catcher?"
  - haml:
      type: boolean
      prompt: Would you like to use Haml instead of ERB?
  - logins:
      type: string
      prompt: "User logins: "
