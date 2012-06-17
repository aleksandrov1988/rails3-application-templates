after_bundler do

  say_wizard "HomePage recipe running 'after bundler'"

  # remove the default home page
  remove_file 'public/index.html'
  remove_file 'public/rails.png'

  # create a home controller and view
  generate(:controller, "home index")

  # set up a simple home page (with placeholder content)
  use_haml=recipes.any? { |r| r=~/haml/ }
  ext=use_haml ? 'haml' : 'erbs'
  remove_file "app/views/home/index.html.#{ext}"
  create_file "app/views/home/index.html.#{ext}" do
    if use_haml
      <<-'HAML'
%h3 Home
      HAML
    else
      <<-ERB
<h3>Home</h3>
      ERB
    end
  end

  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

end

__END__

name: aai10_home
description: "Create a simple home page (creates a home controller and view)."
author: aai10

category: other
tags: [utilities, configuration]
