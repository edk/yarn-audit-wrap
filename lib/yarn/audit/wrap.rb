# frozen_string_literal: true

require "json"
require "yaml"
require "date"
require_relative "wrap/audit_parser"
require_relative "wrap/config"
require_relative "wrap/opt_parser"
require_relative "wrap/version"
require_relative "wrap/yarn_command"
require "active_support/all"

module Yarn
  module Audit
    module Wrap
      class Error < StandardError; end

      class FileNotFoundError < StandardError; end

      class MissingOptionValueError < StandardError; end

      class BadLevelOptionValueError < StandardError; end

      class UnknownOptionError < StandardError; end

      class ExitEarlyError < StandardError; end

      class YarnAuditRuntimeError < StandardError; end

      class Main
        def err str
          # While I like the idea of standardrb, its recommendation in this case is absolute garbage.
          # Errors should always go to stderr, not warn.
          $stderr.send(:puts, str)
        end

        def warn str
          $stdout.puts str
        end

        # Initialize the main loop
        #
        # @param args list [Strings] ARGV, can be an empty array, if no options were passed in.
        # In that case, the defaults will be used.
        #
        def initialize args
          @opts = OptParser.new(args)
        rescue FileNotFoundError
          err "File not found"
        rescue MissingOptionValueError
          err "Missing value for option #{$!}"
        end

        def run
          # generates a tmp/yarn-audit.json by default.  Change @opts to rename/move output file.
          cmd = YarnCommand.new(opts: @opts) unless @opts[:skip_audit_gen]
          raise YarnAuditRuntimeError if !cmd
          cmd.run

          # parse output of yarn audit and store
          audit_output = AuditParser.new(opts: @opts)

          # load config, such as ignorelists
          config = Config.new(opts: @opts)

          # check and return results
          rv = process audit_output: audit_output, config: config, opts: @opts

          audit_output.print_summary

          rv.size # number of vulnerabilities.  0 is shell for success, non-zero is failure!
        end

        def process(audit_output:, config:, opts:)
          levels = opts[:audit_levels]
          used = []

          audit_output.select do |item|
            if levels.include?(item["data"]["advisory"]["severity"]) &&
                use_advisory?(advisory: item, config: config)
              used << item
            else
              audit_output.add_ignored type: item["data"]["advisory"]["severity"], val: item
            end
          end

          used
        end

        def handle_advisories(advisories:, summary:, opts:)
          # print if any, return proper exit code
          if advisories && advisories.size > 0
            warn "yarn-audit: #{advisories.size} flagged packages"
            exit 1
          else
            warn "yarn-audit: No advisories flagged."
            warn summary.inspect
            exit 0
          end
        end

        # advisory is a single line from yarn audit --json output
        # config is a set of all the ignore directives.  Find if the advisory is included in
        # the ignore list, and if so see if the values match and if the optional until: date is set.
        # If the Date is present and past, use the advisory, otherwise ignore it until the date is past.
        def use_advisory?(advisory:, config:)
          config.ignores.detect do |ignore_item|
            found = (ignore_item.keys - [:until]).all? do |key|
              (advisory["data"]["advisory"][key] == ignore_item[key])
            end
            if found
              record = advisory["data"]["advisory"]
              if ignore_item[:until]&.past?
                warn "Found expired vulnerability.  Using advisory \"#{record["title"]}\""
              else
                warn "Actively ignoring.  \"#{record["title"]}\""
                return false
              end
            else
              warn "not found"
              return true
            end
          end
          true
        end
      end # Main
    end
  end
end
