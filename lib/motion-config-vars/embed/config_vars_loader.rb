if path = NSBundle.mainBundle.pathForResource("app", ofType:"yml")

  vars_data = YAML.load File.read path

  RMENV = {} # alternative to ENV for the squimish
  [ENV, RMENV].each do |env|
    HashlikeObjectConfigurer.new({
      config_vars_data: vars_data,
      hashlike_object: env,
      config_name_for_facet_named: lambda { |facet_name|
        NSBundle.mainBundle.objectForInfoDictionaryKey facet_name
      }
    }).perform!
  end

else
  puts "WARNING! main bundle missing app.yml"
end

