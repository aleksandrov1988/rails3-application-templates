say_wizard "Write gems.msiu.ru source to Gemfile"
inject_into_file 'Gemfile', :after => "source 'https://rubygems.org'\n" do
"source 'http://msiu:msiu@gems.msiu.ru'\n"
end
__END__

name: aai10_gem_msiu
description: "Add gems.msiu.ru source to Gemfile."
author: aai10

category: other
