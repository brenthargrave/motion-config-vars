class HashlikeObjectConfigurer
  def initialize options={}
    @hashlike_object = options[:hashlike_object]
    raise ArgumentError, "'hashlike_object' missing" unless @hashlike_object
  end
end

