
if config['haml']
  gem 'haml'
  gem 'haml-rails'
else
  recipes.delete('haml')
end

__END__

name: aai10_haml
description: "Utilize Haml instead of ERB."
author: aai10

category: templating
exclusive: templating

config:
  - haml:
      type: boolean
      prompt: Would you like to use Haml instead of ERB?