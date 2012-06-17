
say_wizard "Adding 'aai10-locale'"
gem 'russian'
after_bundler do
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

__END__

name: aai10_locale
description: "Set gem russian and timezone."
author: aai10

category: other
tags: [utilities, configuration]
