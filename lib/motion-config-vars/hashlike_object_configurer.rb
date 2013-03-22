class HashlikeObjectConfigurer

  def initialize options={}
    @hashlike_object = options[:hashlike_object]
    raise ArgumentError, "'hashlike_object' missing" unless @hashlike_object
    @config_vars_data = options[:config_vars_data]
    raise ArgumentError, "'config_vars_data' missing" unless @config_vars_data
    @config_name_for_facet_named = options[:config_name_for_facet_named]
    raise ArgumentError, "'config_name_for_facet_named' missing" unless @config_name_for_facet_named
    unless @config_name_for_facet_named.respond_to? :call
      raise ArgumentError, "'config_name_for_facet_named' must be a closure"
    end
    unless @hashlike_object.respond_to?(:[]=)
      raise ArgumentError, "hashlike_object doesn't respond to []="
    end
  end

end

