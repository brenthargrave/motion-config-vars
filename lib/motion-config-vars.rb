unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'motion-yaml'

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'motion-config-vars/*.rb')).each do |file|
    app.files.unshift file
  end
end

