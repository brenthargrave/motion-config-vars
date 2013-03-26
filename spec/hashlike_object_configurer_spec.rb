describe MotionConfigVars::HashlikeObjectConfigurer do

  before{ @described_class = MotionConfigVars::HashlikeObjectConfigurer }

  shared "a configuration-robust configurer" do

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

      it "raises ConfigurationError unless all configured facets are specified" do
        @options[:config_name_for_facet_named] = lambda { |facet_name| {}[facet_name] }
        lambda do
          @described_class.new @options
        end.should.raise(MotionConfigVars::ConfigurationError).
        message.should.eql "configured facet not specified: API_ENV"
      end

      it "raises ConfigurationError if specified configuration of any facet unavailable" do
        @options[:config_vars_data]["API_ENV"].delete "production"
        lambda do
          @described_class.new @options
        end.should.raise(MotionConfigVars::ConfigurationError).
        message.should.eql "configuration 'production' unavailable for 'API_ENV'"
      end

    end

    describe "#perform!" do

      before { @described_class.new(@options).perform! }

      it "sets top-level key on hashlike_object" do
        @hashlike_object["API_ENV"].should.eql "production"
      end

    end

  end

  describe "provided a standard, hash of hashes configuration structure" do

    before do
      @hashlike_object = {}
      @valid_config_vars_data = {
        "API_ENV" => {
          "development" =>  { "HOST" => "lvh.me:3000" },
          "test" =>  { "HOST" => "lvh.me:3001" },
          "production" =>  { "HOST" => "domain.com" }
        }
      }
      @options = {
        hashlike_object: @hashlike_object,
        config_vars_data: @valid_config_vars_data,
        config_name_for_facet_named: lambda { |facet_name| "production" }
      }
    end

    behaves_like "a configuration-robust configurer"

    describe "#perform!" do

      before { @described_class.new(@options).perform! }

      it "also sets configuration key/value pairs" do
        @hashlike_object["HOST"].should.eql "domain.com"
      end

    end

  end

  describe "provided an environment-names-array configuration structure" do

    before do
      @hashlike_object = {}
      @valid_config_vars_data = {
        "API_ENV" => %w{ development test production }
      }
      @options = {
        hashlike_object: @hashlike_object,
        config_vars_data: @valid_config_vars_data,
        config_name_for_facet_named: lambda { |facet_name| "production" }
      }
    end

    behaves_like "a configuration-robust configurer"

  end

end

