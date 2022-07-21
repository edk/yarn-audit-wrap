module Yarn
  module Audit
    module Wrap
      class AuditParser
        attr_accessor :output

        def initialize opts:
          @opts = opts
          @ignored = {
            info: [],
            low: [],
            moderate: [],
            high: [],
            critical: []
          }
          parse_json_audit
        end

        def parse_json_audit
          audit_json = @opts[:audit_json]
          @output = File.readlines(audit_json).map do |line|
            JSON.parse(line)
          end
        end

        def add_ignored(type:, val:)
          @ignored[type.to_sym] << val
        end

        def select(&blk)
          if @output
            @output.select do |item|
              yield item if item["type"] == "auditAdvisory"
            end
          else
            []
          end
        end

        def get_summary
          @output.detect { |item| item["type"] == "auditSummary" }
        end

        def print_summary
          puts "\nOriginal Yarn Audit:"
          s = get_summary["data"]
          s.each { |k, v| puts "#{k.to_s.rjust(23)}: #{v.inspect}" }

          puts "\nSkipped vulnerabilities:"
          @ignored.each do |k, v|
            puts "#{k.to_s.rjust(23)}: #{v.size}"
          end
        end
      end # class
    end # Wrap
  end
end
