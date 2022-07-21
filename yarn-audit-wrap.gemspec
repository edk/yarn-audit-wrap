# frozen_string_literal: true

require_relative "lib/yarn/audit/wrap/version"

Gem::Specification.new do |spec|
  spec.name = "yarn-audit-wrap"
  spec.version = Yarn::Audit::Wrap::VERSION
  spec.authors = ["Eddy Kim"]
  spec.email = ["eddyhkim@gmail.com"]

  spec.summary = "Run yarn audit and parse json results, for use in CI"
  spec.description = '
  Script to parse and manage different levels of vulnerabilities from `yarn audit` in rails projects.
  Also features a way to temporarily or permanently ignore vulnerabilities, due to
  false positives or no alternatives for unfixed packages.'
  spec.homepage = "https://github.com/edk/yarn-audit-wrap"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["yarn_audit_wrap"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "guard-standardrb"
  spec.add_development_dependency "minitest-reporters"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
