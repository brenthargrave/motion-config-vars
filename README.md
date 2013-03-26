# motion-config-vars
## Configure RubyMotion's ENV with a YAML file

This gem brings Rails-on-Heroku-style environment configuration to Rubymotion
development. Fill out a YAML configuration file with top-level keys containing
mutually-exclusive environments, and nest keys below them with values
specific to each environment configuration.

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
```bash
rake archive API_ENV=development
```

...exposes the following in both RM's rake tasks *and* the app's runtime:
```ruby
ENV["API_ENV"] #=> development
ENV["HOST"] #=> lvh.me:3000
```

If touching ENV makes you queasy, not to worry. Pre-existing values aren't
overwritten and an alternative hash-like constant, RMENV, is configured as well.

You might ask why not make "development", "production", etc. the top-level
keys? Why bother requiring an API_ENV? In my experience configuring environements
for API-backed clients is more complex because their configs depend on both the
build style (for example, "development", "adhoc" or "release") *and* the API
they are backed by ("development", "staging", "production"). Using these
"facets" for top-level keys enables much more flexible configuration.

For example, you could expand the above app.yml with...
```yaml
AUDIENCE_ENV:
- developer
- adhoc
- release
```

...and then easily point a dev build at your production API
```bash
rake device API_ENV=production AUDIENCE_ENV=developer
```
...or restrict new features to beta-testers, but only beta-testers:
```bash
rake device API_ENV=production AUDIENCE_ENV=adhoc
```


## Install

Add it to your app's Gemfile:

    gem 'motion-config-vars'

Require it in the app's Rakefile:

    require 'motion-config-vars'

Generate the sample YAML config file:

    rake config:vars:init # generates "./resources/app.yml"


## Usage, with an IMPORTANT caveat

After generating the "resources/app.yml" and filling it out you're *almost*
ready to roll. One more detail.

It seems that RM currently monitors changes to your project's Rakefile, and only
rebuilds your app from the Rakefile's configuration if the file itself has
been modified since the last build.  While using this gem, however, your app's
configuration is *dynamically* updated (specifically, the "app.info_plist"
configuration variable is edited), which RM won't pick up by default. So, to
ensure RM rebuilds from the latest, dynamically-defined values in your Rakefile
it will automatically [touch](http://en.wikipedia.org/wiki/Touch_(Unix)) your
project's Rakefile before any of RM's default, build-triggering tasks.

Git won't care, but you might: use of this gem may increase your project's
average build time. The tradeoff for cleaner configuration has been more than
worthwhile for me, but YMMV.


## Tests

To run the tests, run
```bash
touch Rakefile; bundle exec rake spec BUILD_ENV=test
```
(The gem only embeds its code in the app if a config file is present, so it's
necessary to include a test app.yml to ensure the specs have code to exercise.)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
