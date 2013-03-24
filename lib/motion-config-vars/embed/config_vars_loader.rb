if path = NSBundle.mainBundle.pathForResource("app", ofType:"yml")

  vars_data = YAML.load File.read path

  HashlikeObjectConfigurer.new({
    config_vars_data: vars_data,
    hashlike_object: ENV,
    config_name_for_facet_named: lambda { |facet_name|
      NSBundle.mainBundle.objectForInfoDictionaryKey facet_name
    }
  }).perform!

else
  puts "WARNING! main bundle missing app.yml"
end

