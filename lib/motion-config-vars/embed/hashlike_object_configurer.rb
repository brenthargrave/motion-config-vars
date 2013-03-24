class HashlikeObjectConfigurer

  def initialize options={}
    @hashlike_object = options[:hashlike_object]
    raise ArgumentError, "'hashlike_object' missing" unless @hashlike_object
    @config_vars_data = options[:config_vars_data]
    raise ArgumentError, "'config_vars_data' missing" unless @config_vars_data
    @config_name_for_facet_named = options[:config_name_for_facet_named]
    raise ArgumentError, "'config_name_for_facet_named' missing" unless @config_name_for_facet_named
    self.validate_config_name_for_facet_named_is_closure
    self.validate_hashlike_object_is_hashlike
    self.validate_all_configured_facets_are_requested
    self.validate_all_facets_requested_configurations_available
  end

  def perform!
    self.requested_facets_names.each do |requested_facet_name|
      configuration_name = @config_name_for_facet_named.call requested_facet_name
      self.set requested_facet_name, configuration_name
      facet_data = @config_vars_data[requested_facet_name]
      return unless facet_data.is_a? Hash
      configuration_data = facet_data[configuration_name]
      configuration_data.each { |key, value| self.set key, value }
    end
  end

protected

  def set key, value
    @hashlike_object[key] ||= value
  end

  def validate_config_name_for_facet_named_is_closure
    unless @config_name_for_facet_named.respond_to? :call
      raise ArgumentError, "'config_name_for_facet_named' must be a closure"
    end
  end

  def validate_hashlike_object_is_hashlike
    unless @hashlike_object.respond_to?(:[]=)
      raise ArgumentError, "hashlike_object must respond to []="
    end
  end

  def validate_all_configured_facets_are_requested
    unless self.all_configured_facets_are_requested?
      names = self.unrequested_configured_facets_names.join ", "
      raise ArgumentError, "configured facet not specified: #{names}"
    end
  end

  def all_configured_facets_are_requested?
    self.configured_facets_names.all? do |facet_name|
      self.requested_facets_names.include? facet_name
    end
  end

  def configured_facets_names
    @config_vars_data.keys
  end

  def unrequested_configured_facets_names
    self.configured_facets_names - requested_facets_names
  end

  def requested_facets_names
    self.configured_facets_names.map do |facet_name|
      facet_name if @config_name_for_facet_named.call(facet_name)
    end
  end

  def validate_all_facets_requested_configurations_available
    self.requested_facets_names.each do |requested_facet_name|
      configuration_name = @config_name_for_facet_named.call requested_facet_name
      facet_data = @config_vars_data[requested_facet_name]
      unless (facet_data.is_a?(Hash) && facet_data[configuration_name]) or
             (facet_data.is_a?(Array) && facet_data.include?(configuration_name))
        raise ArgumentError, "configuration '#{configuration_name}' unavailable for '#{requested_facet_name}'"
      end
    end
  end

end

