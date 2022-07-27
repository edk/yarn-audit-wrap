# Yarn::Audit::Wrap

This is a ruby gem to parse the result of `yarn audit --json`.  You can filter
different levels of findings, and ignore specific findings for a set time.

It needs as input the json file, and a YAML configuration file with directives on
individual findings to ignore.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add yarn-audit-wrap

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install yarn-audit-wrap

## Usage
```
yarn-audit --file=<tmp/yarn-audit.json> --level=moderate,high,critical --ignorelist=<config/yarn-audit.yml>

All switches are optional, with defaults as shown above.

--help         This.
--file         json output from "yarn audit". Path is relative to app root.
--level        comma separated list of severity strings (case insensitive).
               INFO
               LOW
               MODERATE
               HIGH
               CRITICAL
               or use "ALL" to select all levels.
--ignorelist   path relative to app root, a YAML file containing list of packages to ignore, see below for format.
              default = config/yarn-audit.yml

The ignorelist is a YAML file of an array of hashes
```

Sample YAML:
```
---
:ignore:
- github_advisory_id: GHSA-cj88-88mr-972w
  :until: 2022-07-19
```

You can identify a finding by any key, `github_advisory_id`, `cve`, etc.  Please use
the `:until` key with a date in the future that will re-enable the finding to avoid
config pollution, as well as pushing for best-practices to remove vulnerable packages.

## Possible future enhancements
The next logical step would be to implement a workflow that helps fix vulnerable npm packages.
There is currently no equivalent to `npm audit --fix` for yarn, and ignoring the controversy
(<https://github.com/yarnpkg/yarn/issues/7075>), there are a number of workarounds
that are currently in place.

This will be the next step, but it is my hope that yarn implements the `--fix` feature
and such a workaround will be unnecessary.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edk/yarn-audit-wrap

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
