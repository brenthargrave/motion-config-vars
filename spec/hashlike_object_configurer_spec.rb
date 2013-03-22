describe HashlikeObjectConfigurer do

  before{ @described_class = HashlikeObjectConfigurer }

  describe "initialization" do

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

    [:hashlike_object, :config_vars_data, :config_name_for_facet_named].each do |attr|
      it "raises ArgumentError without #{attr}" do
        lambda do
          @described_class.new @options.tap { |options| options.delete(attr) }
        end.should.raise ArgumentError, "'#{attr}' missing"
      end
    end

    it "raises ArgumentError if :config_name_for_facet_named isn't a closure" do
      @options[:config_name_for_facet_named] = "not-a-closure"
      lambda do
        @described_class.new @options
      end.should.raise ArgumentError, "'config_name_for_facet_named' must be a closure"
    end

    it "raises ArgumentError if :hashlike_object isn't hashlike" do
      unhashlike_object = Object.new
      @options[:hashlike_object] = unhashlike_object
      lambda do
        @described_class.new @options
      end.should.raise ArgumentError, "hashlike_object must respond to []="
    end

    it "raises RuntimeError unless all configured facets are specified" do
      @options[:config_name_for_facet_named] = lambda { Hash.new }
      lambda do
        @described_class.new @options
      end.should.raise RuntimeError, "configured facet not specified: API_ENV"
    end

  end

end

