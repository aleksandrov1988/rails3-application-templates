gem 'rspec', :group =>[:development,:test]
gem 'rspec-rails', :group =>[:development,:test]
gem 'factory_girl', :group =>[:development,:test]

after_bundler do
  generate 'rspec:install'
end

__END__

name: aai10_rspec
description: "Use Rspec framework"
author: aai10

category: tests
tags: [tests, framework]
