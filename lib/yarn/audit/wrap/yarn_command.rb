require "fileutils"
require "shellwords"

module Yarn
  module Audit
    module Wrap
      class YarnCommand
        def initialize opts:
          @opts = opts
        end

        def run
          filepath = @opts[:audit_json].to_s
          FileUtils.mkdir_p File.dirname(filepath)
          outfile = Shellwords.escape(filepath)
          system("yarn audit --json > #{outfile}")
        end
      end
    end # Wrap
  end
end
