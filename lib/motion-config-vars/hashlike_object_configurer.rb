class ConfigurationError < Exception; end;

class HashlikeObjectConfigurer

  attr_reader :hashlike_object, :config_vars_data, :config_name_for_facet_named

  def initialize options={}
    @hashlike_object = options[:hashlike_object]
    raise ArgumentError, "'hashlike_object' missing" unless @hashlike_object
    @config_vars_data = options[:config_vars_data]
    raise ArgumentError, "'config_vars_data' missing" unless @config_vars_data
    @config_name_for_facet_named = options[:config_name_for_facet_named]
    raise ArgumentError, "'config_name_for_facet_named' missing" unless @config_name_for_facet_named
    self.validate_config_name_for_facet_named_is_closure
    self.validate_hashlike_object_is_hashlike
    self.validate_all_configured_facets_are_specified
  end

protected

  def validate_config_name_for_facet_named_is_closure
    unless self.config_name_for_facet_named.respond_to? :call
      raise ArgumentError, "'config_name_for_facet_named' must be a closure"
    end
  end

  def validate_hashlike_object_is_hashlike
    unless self.hashlike_object.respond_to?(:[]=)
      raise ArgumentError, "hashlike_object doesn't respond to []="
    end
  end

  def validate_all_configured_facets_are_specified
    unless self.all_configured_facets_are_specified?
      raise RuntimeError, "configured facet not specified: API_ENV"
    end
  end

  def all_configured_facets_are_specified?
    self.configured_facets_names.all? do |facet_name|
      self.config_name_for_facet_named.call facet_name
    end
  end

  def configured_facets_names
    self.config_vars_data.keys
  end

end

