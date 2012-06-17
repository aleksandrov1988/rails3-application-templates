gem 'twitter-bootstrap-rails', :group => :assets
# please install gem 'therubyracer' to use Less
gem 'therubyracer', :group => :assets, :platform => :ruby
after_bundler do
  say_wizard "Bootstrap recipe running 'after bundler'"
  generate 'bootstrap:install'
  layout_type=config['layout']
  extname= recipes.any?{|r| r=~/haml/} ? 'haml' : 'erb'
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
end
__END__

name: aai10_bootstrap
description: "Install Bootstrap and generate layout."
author: aai10

category: other
tags: [utilities, configuration]

config:
  - layout:
      type: multiple_choice
      prompt: "Which layout type do you prefer?"
      choices: [["Fixed", fixed],["Fluid", fluid]]
