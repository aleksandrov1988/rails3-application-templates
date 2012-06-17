logins=config['logins'].split(/[\s,]+/)
if logins.any?
  append_file 'db/seeds.rb', logins.map { |l| "User.create(:login=>'#{l}')" }.join("\n")
end

after_bundler do
  generate 'model User login'
  rake 'db:migrate'
  rake 'db:seed'
end

__END__

name: aai10_user
description: "User model."
author: aai10

category: other
tags: [utilities, configuration, authentication]

config:
  - logins:
      type: string
      prompt: "User logins: "
