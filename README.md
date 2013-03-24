# motion-config-vars

This gem brings Rails-on-Heroku inspired environment configuration to Rubymotion
development. Fill out a YAML configuration file with top-level keys expressing
mutually-exclusive environments, and nest keys below them with values
specific to each environment option.

For example, setting up an env.yml like so...
```yaml
API_ENV:
  development:
    HOST: "lvh.me:3000"
  test:
    HOST: "lvh.me:3001"
  production:
    HOST: "domain.com"
```

...and then passing a value for your top-level key, like so:
```ruby
rake archive API_ENV=development
```

...exposes the following in *both* the generated task and the app's runtime:
```ruby
ENV["API_ENV"] #=> development
ENV["HOST"] #=> lvh.me:3000
```

You might ask why not make "development", "production", etc. the top-level
keys? Why bother requiring an API_ENV? In my experience configuring environements
for API-backed clients is more complex because their configs depend on both the
build style (for example, "development", "adhoc" or "release") *and* the API
they are backed by ("development", "staging", "production"). Using these
"facets" for top-level keys supports these permutations.


## Install

Add it to your app's Gemfile (you *are* using Bundler, right?):

    gem 'motion-config-vars'

Require it in the app's Rakefile:

    require 'motion-config-vars'

Generate the sample YAML config file:

    rake env:init # generates "./resources/env.yml"


## Usage, with an IMPORTANT caveat

After generating the "resources/env.yml" and filling it out you're *almost* ready
to roll. One more detail.

It seems that RM currently monitors changes to your Rakefile, and only
rebuilds your app from your Rakefile's configuration if the Rakefile itself has
been touched since the last build.  Using this gem, your configuration values
may change depending on what config-vars you pass to your rake tasks.

To ensure RM rebuilds from configuration every time, you **MUST** re-touch your
Rakefile before running a build task. If you don't, the built app may not have
the env vars you *think* it does.  Fortunately, this is as easy as adding a
shell alias for your build task:
```bash
alias beta="touch Rakefile; bundle exec rake archive API_ENV=production"
```

I have a slew of similar aliases (terser and refactored, of course) that
capture all required permutations of build type and API environment.


## Tests

To run the tests, run
```bash
touch Rakefile; bundle exec rake spec BUILD_ENV=test
```
(The gem only embeds its code in the app if a config file is present, so its
necessary to include a test app.yml to ensure the specs have code to exercise.)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
