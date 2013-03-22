describe HashlikeObjectConfigurer do

  before{ @described_class = HashlikeObjectConfigurer }

  before do
    @valid_config_vars_data = {
      "API_ENV" => {
        "development" => "lvh.me:3000",
        "test" => "lvh.me:3001",
        "production" => "domain.com"
      }
    }
    @options = {
      hashlike_object: {},
      config_vars_data: @valid_config_vars_data,
      config_name_for_facet_named: lambda { |facet_name| "production" }
    }
  end

  describe "initialization" do

    it "with valid arguments does not raise exception" do
      lambda do
        begin
          @described_class.new @options
        rescue => exception
          puts exception
        end
      end.should.not.raise(Exception)
    end

    [:hashlike_object, :config_vars_data, :config_name_for_facet_named].each do |attr|
      it "raises ArgumentError without #{attr}" do
        lambda do
          @described_class.new @options.tap { |options| options.delete(attr) }
        end.should.raise(ArgumentError).
        message.should.eql "'#{attr}' missing"
      end
    end

    it "raises ArgumentError if :config_name_for_facet_named isn't a closure" do
      @options[:config_name_for_facet_named] = "not-a-closure"
      lambda do
        @described_class.new @options
      end.should.raise(ArgumentError).
      message.should.eql "'config_name_for_facet_named' must be a closure"
    end

    it "raises ArgumentError if :hashlike_object isn't hashlike" do
      unhashlike_object = Object.new
      @options[:hashlike_object] = unhashlike_object
      lambda do
        @described_class.new(@options).perform!
      end.should.raise(ArgumentError).
      message.should.eql "hashlike_object must respond to []="
    end

  end

  describe "#perform!" do

    # TODO: below, replace ArgumentError with custom ConfigurationError
    it "raises ArgumentError unless all configured facets are specified" do
      @options[:config_name_for_facet_named] = lambda { |facet_name| {}[facet_name] }
      lambda do
        @described_class.new(@options).perform!
      end.should.raise(ArgumentError).
      message.should.eql "configured facet not specified: API_ENV"
    end

    it "raises ArgumentError if specified configuration of any facet unavailable" do
      @options[:config_vars_data]["API_ENV"].delete "production"
      lambda do
        @described_class.new(@options).perform!
      end.should.raise(ArgumentError).
      message.should.eql "configuration 'production' unavailable for 'API_ENV'"
    end

  end

end

