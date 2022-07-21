module Yarn
  module Audit
    module Wrap
      class OptParser
        attr_accessor :opts

        def audit_levels
          opts[:audit_levels]
        end

        def initialize args, output: $stdout
          @output = output
          @err_output = @output == $stdout ? $stderr : @output
          defaults = {
            audit_config: "config/yarn-audit.yml", # configuration and ignorelists
            audit_json: "tmp/yarn-audit.json", # the result of a yarn audit
            audit_levels: "moderate,high,critical".split(",")
          }

          opts = defaults.dup
          args.each do |arg|
            key, val = arg.split("=")
            case key
            when "--help"
              usage
              raise ExitEarlyError
            when "--skip-audit-gen"
              opts[:skip_audit_gen] = true
            when "--file"
              check_file_exists val
              opts[:audit_json] = val
            when "--level"
              raise MissingOptionValueError.new("missing option for --level") if val.nil?
              opts[:audit_levels] = val.downcase.split(",").map(&:strip)
              levels = %w[info low moderate high critical all]
              opts[:audit_levels] = levels - ["all"] if opts[:audit_levels].include?("all")
              if !(opts[:audit_levels] - levels).empty?
                @err_output.puts "ERROR: Unknown audit level used in --levels option"
                @err_output.puts "       Please check: #{val}"
                @err_output.puts "ABORTING"
                raise BadLevelOptionValueError.new(val.to_s)
              end
            when "--ignorelist"
              opts[:audit_config] = val
              check_file_exists val
            else
              @err_output.puts "ERROR: unknown option: #{key}=#{val}"
              @err_output.puts "aborting."
              raise UnknownOptionError.new("#{key}=#{val}")
            end
          end
          @opts = opts
        end

        def [](key)
          @opts[key]
        end

        def usage
          @output.puts <<~USAGE
            Usage:
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
              TODO: show example and structure of ignorelist file.
          USAGE
        end

        def check_file_exists(filename)
          raise MissingOptionValueError if filename.nil?
          if !File.exist?(filename)
            @err_output.puts "ERROR: missing file #{filename}"
            @err_output.puts "aborting."
            raise FileNotFoundError.new("Missing file #{filename}")
          end
        end
      end # Parser
    end
  end
end
