describe HashlikeObjectConfigurer do

  describe "initialization" do

    before do
      @valid_config_vars_data = {
        "API_ENV" => {
          "development" => "lvh.me:3000",
          "test" => "lvh.me:3001",
          "production" => "domain.com"
        }
      }
      @valid_options = {
        hashlike_object: {},
        config_vars_data: @valid_config_vars_data,
        config_name_for_facet_named: lambda { |facet_name| "production" }
      }
    end

    it "raises argument error without #hashlike_object" do
      lambda do
        HashlikeObjectConfigurer.new @valid_options.tap { |options| options.delete(:hashlike_object) }
      end.should.raise ArgumentError, "'hashlike_object' missing"
    end

  end

end

