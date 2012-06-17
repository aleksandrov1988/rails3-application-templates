say_wizard "Adding 'aai10-cas'"
gem 'rubycas-client-msiu', '>= 1.1'

after_bundler do
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/config/initializers/cas.rb','config/initializers/cas.rb'
  remove_file 'app/controllers/application_controller.rb'
  get 'https://raw.github.com/aleksandrov1988/rails3-application-templates/master/files/controllers/application_controller.rb', 'app/controllers/application_controller.rb'
end
__END__

name: aai10_cas
description: "Cas auth and methods for before_filters."
author: aai10

category: other
tags: [configuration,authentication]