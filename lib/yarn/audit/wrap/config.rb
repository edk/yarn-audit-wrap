module Yarn
  module Audit
    module Wrap
      class Config
        def initialize(opts:)
          # format of config file:
          # hash with ignore: key, an array of hashes.  Each hash can have one or more
          # keys where the value is matched.
          # One additional key is `until: <date>` where the ignore item is resurfaced,
          # to avoid eternal vulnerabilities.
          # YAML.dump({ ignore: [ { "github_adivosry_id" => "GHSA-cj88-88mr-972w" } ] })
          audit_config = opts[:audit_config]
          @config = if File.exist?(audit_config)
            YAML.safe_load(File.read(audit_config), permitted_classes: [Symbol, Date])
          else
            {}
          end
        end

        def ignores
          if @config && @config.size > 0
            @config[:ignore]
          else
            []
          end
        end
      end
    end # Wrap
  end
end
