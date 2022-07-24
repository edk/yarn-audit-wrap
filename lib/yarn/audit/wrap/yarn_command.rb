module Yarn
  module Audit
    module Wrap
      class YarnCommand
        def initialize opts:
          @opts = opts
        end

        def run
          outfile = Shellwords.escape(@opts[:audit_json].to_s)
          system("yarn audit --json > #{outfile}")
        end
      end
    end # Wrap
  end
end
